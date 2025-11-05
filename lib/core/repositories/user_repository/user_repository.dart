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
      final doc =
          await firestore
              .collection("users")
              .doc(_supabase.auth.currentSession?.user.id)
              .get();

      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!);
        return Right(user);
      } else {
        return Left(ExceptionMessage("Usuário não encontrado."));
      }
    } catch (e) {
      return Left(ExceptionMessage("Erro ao buscar usuário: ${e.toString()}"));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> createProfile(UserModel data) async {
    try {
      final now = DateTime.now();
      data.createdAt = data.createdAt ?? now;
      await firestore.collection("users").doc(data.id).set(data.toMap());
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao criar perfil: ${e.toString()}"));
    }
  }

  @override
  Future<Either<ExceptionMessage, String>> getUserName(String userId) async {
    try {
      final doc = await firestore.collection("users").doc(userId).get();

      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromMap(doc.data()!);
        return Right(user.name ?? "Usuário");
      } else {
        return Left(ExceptionMessage("Usuário não encontrado."));
      }
    } catch (e) {
      return Left(ExceptionMessage("Erro ao buscar usuário: ${e.toString()}"));
    }
  }
}
