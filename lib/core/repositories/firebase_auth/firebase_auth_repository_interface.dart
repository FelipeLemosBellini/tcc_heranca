import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';

abstract class FirebaseAuthRepositoryInterface {
  Future<Either<ExceptionMessage, User?>> getCredential();

  Future<Either<ExceptionMessage, String>> createAccount(
      {required String email, required String password});

  Future<Either<ExceptionMessage, bool>> login({required String email, required String password});

  Future<Either<ExceptionMessage, void>> forgotPassword({required String email});

  void logout();
}
