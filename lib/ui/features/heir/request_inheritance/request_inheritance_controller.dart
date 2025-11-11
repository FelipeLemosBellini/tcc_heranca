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

  RequestInheritanceController({
    required this.inheritanceRepository,
  });

  Future<bool> createRequestInheritance({
    required RequestInheritanceModel inheritance,
    required String rg,
    required XFile procuracaoDoInventariante,
    required XFile certidaoDeObito,
    required XFile documentoCpf,
    required XFile enderecoDoInventariante,
    required XFile testamento,
    required XFile transferenciaDeAtivos,
  }) async {
    final requesterId = inheritance.requestById;
    final testatorCpf = inheritance.cpf;
    final inheritanceId = inheritance.id;
    final testatorId = inheritance.testatorId;

    if (requesterId == null || testatorCpf == null || inheritanceId == null || testatorId == null) {
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

    if (!_hasAllFiles([
      procuracaoDoInventariante,
      certidaoDeObito,
      documentoCpf,
      enderecoDoInventariante,
      testamento,
      transferenciaDeAtivos,
    ])) {
      setMessage(
        AlertData(
          message: 'Anexe todos os documentos obrigatórios.',
          errorType: ErrorType.warning,
        ),
      );
      return false;
    }

    setLoading(true);

    final docs = <Document, XFile>{
      Document(
        ownerId: requesterId,
        testatorId: testatorId,
        typeDocument: TypeDocument.procuracaoAdvogado,
        reviewStatus: ReviewStatusDocument.pending,
        reviewMessage: '',
        from: EnumDocumentsFrom.inheritanceRequest,
        uploadedAt: DateTime.now(),
      ): procuracaoDoInventariante,
      Document(
        ownerId: requesterId,
        testatorId: testatorId,
        typeDocument: TypeDocument.deathCertificate,
        reviewStatus: ReviewStatusDocument.pending,
        reviewMessage: '',
        from: EnumDocumentsFrom.inheritanceRequest,
        uploadedAt: DateTime.now(),
      ): certidaoDeObito,
      Document(
        ownerId: requesterId,
        testatorId: testatorId,
        typeDocument: TypeDocument.cpf,
        reviewStatus: ReviewStatusDocument.pending,
        reviewMessage: '',
        from: EnumDocumentsFrom.inheritanceRequest,
        uploadedAt: DateTime.now(),
      ): documentoCpf,
      Document(
        ownerId: requesterId,
        testatorId: testatorId,
        typeDocument: TypeDocument.proofResidence,
        reviewStatus: ReviewStatusDocument.pending,
        reviewMessage: '',
        from: EnumDocumentsFrom.inheritanceRequest,
        uploadedAt: DateTime.now(),
      ): enderecoDoInventariante,
      Document(
        ownerId: requesterId,
        testatorId: testatorId,
        typeDocument: TypeDocument.testamentDocument,
        reviewStatus: ReviewStatusDocument.pending,
        reviewMessage: '',
        from: EnumDocumentsFrom.inheritanceRequest,
        uploadedAt: DateTime.now(),
      ): testamento,
      Document(
        ownerId: requesterId,
        testatorId: testatorId,
        typeDocument: TypeDocument.transferAssetsOrder,
        reviewStatus: ReviewStatusDocument.pending,
        reviewMessage: '',
        from: EnumDocumentsFrom.inheritanceRequest,
        uploadedAt: DateTime.now(),
      ): transferenciaDeAtivos,
    };

    var hasError = false;

    for (final entry in docs.entries) {
      final result = await inheritanceRepository.submit(
        document: entry.key,
        xFile: entry.value,
        inheritanceId: inheritanceId,
        requesterId: requesterId,
        testatorId: testatorId,
      );

      result.fold(
        (error) {
          hasError = true;
          setMessage(
            AlertData(
              message: 'Erro ao enviar documento: ${error.errorMessage}',
              errorType: ErrorType.error,
            ),
          );
        },
        (_) {},
      );

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
              message: 'Documentos enviados, mas houve erro ao atualizar o status: ${error.errorMessage}',
              errorType: ErrorType.warning,
            ),
          );
        },
        (_) {
          setMessage(
            AlertData(
              message: 'Documentos enviados com sucesso!',
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
}
