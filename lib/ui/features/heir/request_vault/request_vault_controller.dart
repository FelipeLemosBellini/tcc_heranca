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
    XFile? certificadoDeObito,
    XFile? procuracaoAdvogado,
    bool requireAll = true,
  }) {
    final hasCertidao =
        certificadoDeObito != null && certificadoDeObito.path.isNotEmpty;
    final hasProcuracao =
        procuracaoAdvogado != null && procuracaoAdvogado.path.isNotEmpty;

    if (requireAll) {
      if (!hasCertidao) {
        setMessage(
          AlertData(
            message: 'Anexe a Certidão de Óbito.',
            errorType: ErrorType.warning,
          ),
        );
        return false;
      }
      if (!hasProcuracao) {
        setMessage(
          AlertData(
            message: 'Anexe a Procuração do Advogado.',
            errorType: ErrorType.warning,
          ),
        );
        return false;
      }
    } else if (!hasCertidao && !hasProcuracao) {
      setMessage(
        AlertData(
          message: 'Envie ao menos um documento corrigido.',
          errorType: ErrorType.warning,
        ),
      );
      return false;
    }

    if (cpfTestator.trim().isEmpty) {
      setMessage(
        AlertData(
          message: 'Informe o CPF do testador.',
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

  Future<bool> resendBalanceDocuments({
    required RequestInheritanceModel inheritance,
    XFile? certificadoDeObito,
    XFile? procuracaoAdvogado,
  }) async {
    final inheritanceId = inheritance.id;
    final requesterId = inheritance.requestById;
    final testatorId = inheritance.testatorId;

    if (inheritanceId == null || requesterId == null || testatorId == null) {
      setMessage(
        AlertData(
          message:
              'Não foi possível reenviar os documentos desta solicitação. Tente novamente.',
          errorType: ErrorType.error,
        ),
      );
      return false;
    }

    setLoading(true);

    bool sent = await submitDocuments(
      cpfTestator: inheritance.cpf ?? '',
      certificadoDeObito: certificadoDeObito,
      procuracaoAdvogado: procuracaoAdvogado,
      inheritanceId: inheritanceId,
      requesterId: requesterId,
      testatorId: testatorId,
      requireAllDocs: false,
      showSuccessMessage: false,
    );

    if (!sent) {
      setLoading(false);
      return false;
    }

    bool updated = false;
    final statusResult = await inheritanceRepository.updateStatus(
      inheritanceId: inheritanceId,
      status: HeirStatus.consultaSaldoSolicitado,
    );

    statusResult.fold(
      (error) {
        setMessage(
          AlertData(
            message:
                'Documentos reenviados, porém ocorreu um erro ao atualizar o status: ${error.errorMessage}',
            errorType: ErrorType.warning,
          ),
        );
      },
      (_) {
        eventBus.fire(TestamentEvent());
        setMessage(
          AlertData(
            message: 'Correções enviadas para análise.',
            errorType: ErrorType.success,
          ),
        );
        updated = true;
      },
    );

    setLoading(false);
    return updated;
  }

  Future<bool> submitDocuments({
    required String cpfTestator,
    XFile? certificadoDeObito,
    XFile? procuracaoAdvogado,
    required String inheritanceId,
    required String requesterId,
    required String testatorId,
    bool requireAllDocs = true,
    bool showSuccessMessage = true,
  }) async {
    if (!_validateInputs(
      cpfTestator: cpfTestator,
      certificadoDeObito: certificadoDeObito,
      procuracaoAdvogado: procuracaoAdvogado,
      requireAll: requireAllDocs,
    )) {
      return false;
    }

    final uploads = <Document, XFile>{};

    if (certificadoDeObito != null) {
      uploads[Document(
            ownerId: requesterId,
            testatorId: testatorId,
            typeDocument: TypeDocument.deathCertificate,
            reviewStatus: ReviewStatusDocument.pending,
            reviewMessage: '',
            from: EnumDocumentsFrom.balanceRequest,
            uploadedAt: DateTime.now(),
          )] =
          certificadoDeObito;
    }

    if (procuracaoAdvogado != null) {
      uploads[Document(
            ownerId: requesterId,
            testatorId: testatorId,
            typeDocument: TypeDocument.procuracaoAdvogado,
            reviewStatus: ReviewStatusDocument.pending,
            reviewMessage: '',
            from: EnumDocumentsFrom.balanceRequest,
            uploadedAt: DateTime.now(),
          )] =
          procuracaoAdvogado;
    }

    if (uploads.isEmpty) {
      return false;
    }

    bool success = true;

    for (final entry in uploads.entries) {
      final result = await inheritanceRepository.submit(
        document: entry.key,
        xFile: entry.value,
        inheritanceId: inheritanceId,
        requesterId: requesterId,
        testatorId: testatorId,
      );

      result.fold((error) {
        success = false;
        setMessage(
          AlertData(
            message: 'Erro ao enviar documentos: ${error.errorMessage}',
            errorType: ErrorType.error,
          ),
        );
      }, (_) {});

      if (!success) break;
    }

    if (success && showSuccessMessage) {
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
