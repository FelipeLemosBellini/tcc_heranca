import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository_interface.dart';

import '../../models/user_model.dart';

class FirestoreRepository implements FirestoreRepositoryInterface {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
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

  @override
  Future<Either<ExceptionMessage, void>> createProfile(
    String uid,
    UserModel data,
  ) async {
    try {
      await firestore.collection("users").doc(uid).set(data.toMap());
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao criar perfil: ${e.toString()}"));
    }
  }

  Future<Either<ExceptionMessage, void>> createTestament({
    required String addressTestator,
    required TestamentModel testament,
  }) async {
    try {
      await firestore
          .collection('testamentos')
          .doc(addressTestator)
          .set(testament.toMap());
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao criar o testamento"));
    }
  }

  Future<Either<ExceptionMessage, TestamentModel>> getTestamentByAddress(
    myAddress,
  ) async {
    try {
      final snapshot = await firestore.collection('testamentos').get();
      QueryDocumentSnapshot<Map<String, dynamic>> response = snapshot.docs
          .firstWhere(
            (testament) => myAddress == testament["testamentAddress"].toString(),
          );
      return Right(TestamentModel.fromDocument(response));
    } catch (e) {
      return Left(ExceptionMessage("Erro ao buscar os testamentos"));
    }
  }

  Future<Either<ExceptionMessage, void>> updateTestament({
    required String addressTestator,
    required TestamentModel testament,
  }) async {
    try {
      await firestore
          .collection('testamentos')
          .doc(addressTestator)
          .update(testament.toMap());
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao atualizar o testamento"));
    }
  }

  Future<Either<ExceptionMessage, void>> deleteTestament({
    required String address,
  }) async {
    try {
      await firestore.collection('testamentos').doc(address).delete();
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao excluir testamento"));
    }
  }
}
