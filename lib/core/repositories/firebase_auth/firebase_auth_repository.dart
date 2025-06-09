import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/repositories/firebase_auth/firebase_auth_repository_interface.dart';

class FirebaseAuthRepository implements FirebaseAuthRepositoryInterface {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<ExceptionMessage, User?>> getCredential() async {
    try {
      return Right(firebaseAuth.currentUser);
    } on FirebaseAuthException catch (error) {
      return Left(ExceptionMessage("Erro ao buscar credenciais"));
    }
  }

  @override
  Future<Either<ExceptionMessage, String>> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      return Right(userCredential.user?.uid ?? "");
    } on FirebaseAuthException catch (error) {
      return Left(ExceptionMessage("Erro ao criar a conta"));
    }
  }

  @override
  Future<Either<ExceptionMessage, bool>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      return Right(
        userCredential.user?.uid != null &&
            (userCredential.user?.uid.isNotEmpty ?? false),
      );
    } on FirebaseAuthException catch (error) {
      return Left(ExceptionMessage("Erro ao entrar na sua conta"));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);

      return const Right(null);
    } on FirebaseAuthException catch (error) {
      return Left(ExceptionMessage("Erro ao enviar email"));
    }
  }

  @override
  Future<void> signOut() => firebaseAuth.signOut();
}
