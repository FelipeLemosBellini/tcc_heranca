import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';
import 'package:tcc/core/events/testament_event.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class RequestInheritanceController extends BaseController {
  final InheritanceRepositoryInterface inheritanceRepository;
  final EventBus eventBus = GetIt.I.get<EventBus>();

  RequestInheritanceController({required this.inheritanceRepository});

  Future<bool> createRequestInheritance({
    required RequestInheritanceModel inheritance,
    required String rg,
    XFile? procuracaoDoInventariante,
    XFile? certidaoDeObito,
    XFile? documentoCpf,
    XFile? enderecoDoInventariante,
    XFile? testamento,
    XFile? transferenciaDeAtivos,
  }) async {
    final requesterId = inheritance.requestById;
    final testatorCpf = inheritance.cpf;
    final inheritanceId = inheritance.id;
    final testatorId = inheritance.testatorId;
    final isCorrection =
        inheritance.heirStatus == HeirStatus.transferenciaSaldoRecusado;

    if (requesterId == null ||
        testatorCpf == null ||
        inheritanceId == null ||
        testatorId == null) {
      setMessage(
        AlertData(
          message:
              'Informações do processo de herança incompletas. Tente novamente mais tarde.',
          errorType: ErrorType.error,
        ),
      );
      return false;
    }

    if (rg.isEmpty) {
      setMessage(
        AlertData(
          message: 'Informe o RG do testador.',
          errorType: ErrorType.warning,
        ),
      );
      return false;
    }

    final files = [
      procuracaoDoInventariante,
      certidaoDeObito,
      documentoCpf,
      enderecoDoInventariante,
      testamento,
      transferenciaDeAtivos,
    ];

    if (!isCorrection && !_hasAllFiles(files)) {
      setMessage(
        AlertData(
          message: 'Anexe todos os documentos obrigatórios.',
          errorType: ErrorType.warning,
        ),
      );
      return false;
    } else if (isCorrection && !_hasAnyFile(files)) {
      setMessage(
        AlertData(
          message: 'Selecione pelo menos um documento para reenviar.',
          errorType: ErrorType.warning,
        ),
      );
      return false;
    }

    setLoading(true);

    final docs = <Document, XFile>{};

    void addDoc(XFile? file, TypeDocument type) {
      if (file == null) return;
      docs[Document(
            ownerId: requesterId,
            testatorId: testatorId,
            typeDocument: type,
            reviewStatus: ReviewStatusDocument.pending,
            reviewMessage: '',
            from: EnumDocumentsFrom.inheritanceRequest,
            uploadedAt: DateTime.now(),
          )] =
          file;
    }

    addDoc(procuracaoDoInventariante, TypeDocument.procuracaoAdvogado);
    addDoc(certidaoDeObito, TypeDocument.deathCertificate);
    addDoc(documentoCpf, TypeDocument.cpf);
    addDoc(enderecoDoInventariante, TypeDocument.proofResidence);
    addDoc(testamento, TypeDocument.testamentDocument);
    addDoc(transferenciaDeAtivos, TypeDocument.transferAssetsOrder);

    var hasError = false;

    for (final entry in docs.entries) {
      final result = await inheritanceRepository.submit(
        document: entry.key,
        xFile: entry.value,
        inheritanceId: inheritanceId,
        requesterId: requesterId,
        testatorId: testatorId,
      );

      result.fold((error) {
        hasError = true;
        setMessage(
          AlertData(
            message: 'Erro ao enviar documento: ${error.errorMessage}',
            errorType: ErrorType.error,
          ),
        );
      }, (_) {});

      if (hasError) break;
    }

    var completed = false;

    if (!hasError) {
      inheritance.rg = rg;
      inheritance.heirStatus = HeirStatus.transferenciaSaldoSolicitado;
      inheritance.updatedAt = DateTime.now();
      final updateResult = await inheritanceRepository.updateStatus(
        inheritanceId: inheritanceId,
        status: HeirStatus.transferenciaSaldoSolicitado,
        additionalData: {'rg': rg},
      );

      updateResult.fold(
        (error) {
          setMessage(
            AlertData(
              message:
                  'Documentos enviados, mas houve erro ao atualizar o status: ${error.errorMessage}',
              errorType: ErrorType.warning,
            ),
          );
        },
        (_) {
          setMessage(
            AlertData(
              message:
                  isCorrection
                      ? 'Correções enviadas para análise!'
                      : 'Documentos enviados com sucesso!',
              errorType: ErrorType.success,
            ),
          );
          eventBus.fire(TestamentEvent());
          completed = true;
        },
      );
    }

    setLoading(false);
    return !hasError && completed;
  }

  bool _hasAllFiles(List<XFile?> files) {
    for (final file in files) {
      if (file == null || file.path.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool _hasAnyFile(List<XFile?> files) {
    for (final file in files) {
      if (file != null && file.path.isNotEmpty) {
        return true;
      }
    }
    return false;
  }
}
