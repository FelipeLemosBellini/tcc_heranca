import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_model.dart';

abstract class UserRepositoryInterface {
  Future<Either<ExceptionMessage, UserModel>> getUser();

  Future<Either<ExceptionMessage, void>> createProfile(UserModel data);

  Future<Either<ExceptionMessage, String>> getUserName(String userId);
}
