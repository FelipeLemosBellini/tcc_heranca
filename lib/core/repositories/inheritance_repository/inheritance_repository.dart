import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';

class InheritanceRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final StorageRepository storageRepository;

  InheritanceRepository({required this.storageRepository});

  Future<Either<ExceptionMessage, String>> createInheritance(
    RequestInheritanceModel requestInheritanceModel,
  ) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }

      requestInheritanceModel.requestById = uid;

      final response =
          await firestore
              .collection("users")
              .where('cpf', isEqualTo: requestInheritanceModel.cpf)
              .get();

      if (response.docs.isEmpty) {
        return Left(
          ExceptionMessage(
            "Não encontramos nenhum usuário com o CPF informado.",
          ),
        );
      }

      final userDoc = response.docs.first;
      final user = UserModel.fromMap(userDoc.data())..id = userDoc.id;

      requestInheritanceModel.userId = user.id;
      requestInheritanceModel.name = user.name;

      final inheritanceCollection = firestore.collection("inheritance");
      final docRef = inheritanceCollection.doc();
      await docRef.set(requestInheritanceModel.toMap());

      return Right(docRef.id);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, void>> submit({
    required Document document,
    required XFile xFile,
  }) async {
    try {
      String typeImage = xFile.path.split('.').last;
      document.pathStorage =
          'inheritance/${document.idDocument}/documents/${document.typeDocument.name}.$typeImage';
      await storageRepository.saveFile(
        xFile: xFile,
        namePath: document.pathStorage ?? "",
      );

      await firestore.collection("documents").doc().set(document.toMap());

      return const Right(null);
    } catch (e) {
      return Left(ExceptionMessage('Erro ao enviar KYC: ${e.toString()}'));
    }
  }

  Future<Either<ExceptionMessage, List<RequestInheritanceModel>>>
  getInheritancesByUserId() async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }

      var response =
          await firestore
              .collection("inheritance")
              .where('requestById', isEqualTo: uid)
              .get();

      var inheritances =
          response.docs
              .map(
                (doc) =>
                    RequestInheritanceModel.fromMap(doc.data())..id = doc.id,
              )
              .toList();

      return Right(inheritances);
    } catch (e) {
      return Left(ExceptionMessage('Erro ao buscar heranças: ${e.toString()}'));
    }
  }
}
