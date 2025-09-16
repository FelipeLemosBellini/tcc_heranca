import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_document.dart';
import 'package:tcc/core/models/user_model.dart';

abstract class BackofficeFirestoreInterface {
  Future<Either<ExceptionMessage, List<UserModel>>> getUsers();

  Future<Either<ExceptionMessage, List<UserDocument>>> getDocumentsByUserId({
    required String userId,
  });

  Future<Either<ExceptionMessage, void>> changeStatusDocument({
    required String documentId,
    required bool status,
  });

  Future<Either<ExceptionMessage, void>> changeStatusUser({
    required String userId,
    required bool status,
  });
}
