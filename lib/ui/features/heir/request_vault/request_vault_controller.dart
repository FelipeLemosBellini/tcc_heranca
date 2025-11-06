import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/enum/heir_status.dart';

import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/events/testament_event.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository_interface.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

// Reaproveitando os seus modelos/enums:
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';


class RequestVaultController extends BaseController {
  final UserRepositoryInterface userRepository;
  final InheritanceRepositoryInterface inheritanceRepository;
  final EventBus eventBus = GetIt.I.get<EventBus>();

  RequestVaultController({
    required this.userRepository,
    required this.inheritanceRepository,
  });

  final TextEditingController cpfHeirController = TextEditingController();
  final TextEditingController cpfTestatorController = TextEditingController();

  final FocusNode cpfHeirFocus = FocusNode();
  final FocusNode cpfTestatorFocus = FocusNode();

  bool _validateInputs({
    required String cpfTestator,
    required XFile certificadoDeObito,
    required XFile procuracaoAdvogado,
  }) {
    if (certificadoDeObito.path.isEmpty) {
      setMessage(
        AlertData(
          message: 'Anexe a Certidão de Óbito.',
          errorType: ErrorType.warning,
        ),
      );
      return false;
    }
    if (procuracaoAdvogado.path.isEmpty) {
      setMessage(
        AlertData(
          message: 'Anexe a Procuração do Advogado.',
          errorType: ErrorType.warning,
        ),
      );
      return false;
    }
    return true;
  }

  Future<bool> createRequestInheritance({
    required String cpfTestator,
    required XFile certificadoDeObito,
    required XFile procuracaoAdvogado,
  }) async {
    if (!_validateInputs(
      cpfTestator: cpfTestator,
      certificadoDeObito: certificadoDeObito,
      procuracaoAdvogado: procuracaoAdvogado,
    )) {
      return false;
    }

    setLoading(true);

    final requestInheritance = RequestInheritanceModel(
      cpf: cpfTestator,
      heirStatus: HeirStatus.consultaSaldoSolicitado,
    );

    final result = await inheritanceRepository.createInheritance(
      requestInheritance,
    );

    bool created = false;

    await result.fold<Future<void>>(
      (error) async {
        setMessage(
          AlertData(
            message: 'Erro ao criar solicitação: ${error.errorMessage}',
            errorType: ErrorType.error,
          ),
        );
      },
      (creation) async {
        created = await submitDocuments(
          cpfTestator: cpfTestator,
          certificadoDeObito: certificadoDeObito,
          procuracaoAdvogado: procuracaoAdvogado,
          inheritanceId: creation.inheritanceId,
          requesterId: creation.requesterId,
          testatorId: creation.testatorId,
        );

        if (created) {
          eventBus.fire(TestamentEvent());
          setMessage(
            AlertData(
              message: 'Solicitação criada com sucesso!',
              errorType: ErrorType.success,
            ),
          );
        }
      },
    );

    setLoading(false);
    return created;
  }

  Future<bool> submitDocuments({
    required String cpfTestator,
    required XFile certificadoDeObito,
    required XFile procuracaoAdvogado,
    required String inheritanceId,
    required String requesterId,
    required String testatorId,
  }) async {
    if (!_validateInputs(
      cpfTestator: cpfTestator,
      certificadoDeObito: certificadoDeObito,
      procuracaoAdvogado: procuracaoAdvogado,
    )) {
      return false;
    }

    final obitoDocument = Document(
      ownerId: requesterId,
      testatorId: testatorId,
      typeDocument: TypeDocument.deathCertificate,
      reviewStatus: ReviewStatusDocument.pending,
      reviewMessage: '',
      from: EnumDocumentsFrom.inheritanceRequest,
      uploadedAt: DateTime.now(),
    );

    final procuracaoAdvogadoDocument = Document(
      ownerId: requesterId,
      testatorId: testatorId,
      typeDocument: TypeDocument.procuracaoAdvogado,
      reviewStatus: ReviewStatusDocument.pending,
      reviewMessage: '',
      from: EnumDocumentsFrom.inheritanceRequest,
      uploadedAt: DateTime.now(),
    );

    var resultObito = await inheritanceRepository.submit(
      document: obitoDocument,
      xFile: certificadoDeObito,
      inheritanceId: inheritanceId,
      requesterId: requesterId,
      testatorId: testatorId,
    );

    var resultProcuracao = await inheritanceRepository.submit(
      document: procuracaoAdvogadoDocument,
      xFile: procuracaoAdvogado,
      inheritanceId: inheritanceId,
      requesterId: requesterId,
      testatorId: testatorId,
    );

    bool success = true;

    resultObito.fold(
      (error) {
        success = false;
        setMessage(
          AlertData(
            message: 'Erro ao enviar documentos: ${error.errorMessage}',
            errorType: ErrorType.error,
          ),
        );
      },
      (_) {},
    );

    resultProcuracao.fold(
      (error) {
        success = false;
        setMessage(
          AlertData(
            message: 'Erro ao enviar documentos: ${error.errorMessage}',
            errorType: ErrorType.error,
          ),
        );
      },
      (_) {},
    );

    if (success) {
      setMessage(
        AlertData(
          message: 'Documentos enviados com sucesso!',
          errorType: ErrorType.success,
        ),
      );
    }

    return success;
  }
}
