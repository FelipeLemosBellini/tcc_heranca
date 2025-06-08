import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';

import '../../models/user_model.dart';

class FirestoreRepository implements FirestoreRepositoryInterface {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<ExceptionMessage, UserModel>> getUser() async {
    try {
      final doc = await firestore.collection("users").doc(firebaseAuth.currentUser?.uid).get();

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
  Future<Either<ExceptionMessage, void>> createProfile(String uid, Map<String, dynamic> data) async {
    try {
      await firestore.collection("users").doc(uid).set(data);
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao criar perfil: ${e.toString()}"));
    }
  }
}
