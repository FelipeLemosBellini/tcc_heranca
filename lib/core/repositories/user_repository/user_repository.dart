import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_model.dart';

class UserRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Either<ExceptionMessage, UserModel>> getUser() async {
    try {
      final doc =
          await firestore
              .collection("users")
              .doc(firebaseAuth.currentUser?.uid)
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

  Future<Either<ExceptionMessage, void>> createProfile(UserModel data) async {
    try {
      await firestore.collection("users").doc(data.id).set(data.toMap());
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao criar perfil: ${e.toString()}"));
    }
  }

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
