import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';

class UserRepository implements UserRepositoryInterface {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<Either<ExceptionMessage, UserModel>> getUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return Left(ExceptionMessage("User not found"));
      final details =
          await _supabase
              .from('users')
              .select()
              .eq('id', user.id)
              .maybeSingle();

      return Right(UserModel.fromMap(details!));
    } catch (e) {
      return Left(ExceptionMessage("Erro ao buscar usuário: ${e.toString()}"));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> createProfile(UserModel data) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Sem usuário autenticado');

      final now = DateTime.now();
      data.createdAt = data.createdAt ?? now;
      data.id = user.id;
      await _supabase.from('users').upsert(data.toMap(), onConflict: 'id');

      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao criar perfil: ${e.toString()}"));
    }
  }

  @override
  Future<Either<ExceptionMessage, String>> getUserName(String userId) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Sem usuário autenticado');

      var response =
          await _supabase.from('users').select('name').eq('id', userId).single();

      return Right(response['name']);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao buscar usuário: ${e.toString()}"));
    }
  }
}
