import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/repositories/firebase_auth/auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  @override
  Future<Either<ExceptionMessage, String>> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      AuthResponse authResponse = await _supabaseClient.auth.signUp(
        password: password,
        email: email,
      );

      return Right(authResponse.user!.id);
    } on AuthException catch (error) {
      return Left(ExceptionMessage("Erro ao criar a conta"));
    }
  }

  @override
  Future<Either<ExceptionMessage, bool>> login({
    required String email,
    required String password,
  }) async {
    try {
      AuthResponse userCredential = await _supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      return Right(
        userCredential.user?.id != null &&
            (userCredential.user?.id.isNotEmpty ?? false),
      );
    } on AuthException catch (error) {
      return Left(ExceptionMessage("Erro ao entrar na sua conta"));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> forgotPassword({
    required String email,
  }) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);

      return const Right(null);
    } on AuthException catch (error) {
      return Left(ExceptionMessage("Erro ao enviar email"));
    }
  }

  @override
  Future<void> signOut() async => await _supabaseClient.auth.signOut();
}
