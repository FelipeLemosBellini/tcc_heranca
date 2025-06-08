import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_model.dart';

abstract class FirestoreRepositoryInterface {
  Future<Either<ExceptionMessage, UserModel>> getUser();
}
