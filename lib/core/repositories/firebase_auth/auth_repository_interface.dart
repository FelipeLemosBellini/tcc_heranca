import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';

abstract class AuthRepositoryInterface {
  Future<Either<ExceptionMessage, String>> createAccount({
    required String email,
    required String password,
  });

  Future<Either<ExceptionMessage, bool>> login({
    required String email,
    required String password,
  });

  Future<Either<ExceptionMessage, void>> forgotPassword({
    required String email,
  });

  void signOut();
}
