import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/testator_summary.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/models/user_model.dart';

abstract class BackofficeFirestoreInterface {
  Future<Either<ExceptionMessage, List<UserModel>>> getUsersPendentes({
    EnumDocumentsFrom? from,
  });

  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByUserId({
    required String userId,
    String? testatorId,
    EnumDocumentsFrom? from,
    bool onlyPending = true,
  });

  Future<Either<ExceptionMessage, List<TestatorSummary>>>
  getTestatorsByRequester({required String requesterId});

  Future<Either<ExceptionMessage, void>> updateInheritanceStatus({
    required String requesterId,
    required String testatorId,
    required HeirStatus status,
  });

  Future<Either<ExceptionMessage, List<RequestInheritanceModel>>>
  getCompletedInheritances();

  Future<Either<ExceptionMessage, void>> changeStatusDocument({
    required String documentId,
    required bool status,
    String? reason,
  });

  Future<Either<ExceptionMessage, void>> updateStatusUser({
    required bool hasInvalidDocument,
    required String userId,
  });

  Future<Either<ExceptionMessage, void>> sendEmailWithBalance({
    required String balance,
    required String requestUserId,
    required String cpf,
  });
}
