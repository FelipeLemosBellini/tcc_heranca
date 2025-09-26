import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';

class InheritanceRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final StorageRepository storageRepository;

  InheritanceRepository({required this.storageRepository});

  Future<Either<ExceptionMessage, void>> createInheritance(
    RequestInheritanceModel requestInheritanceModel,
  ) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }

      requestInheritanceModel.requestById = uid;

      await firestore
          .collection("inheritance")
          .doc()
          .set(requestInheritanceModel.toMap());

      return Right('');
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, void>> submit({
    required Document userDocument,
    required String inheritanceId,
    required XFile xFile,
  }) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }
      userDocument.id = uid;

      String typeImage = xFile.path.split('.').last;
      userDocument.pathStorage =
      'inheritance/$inheritanceId/documents/${userDocument.typeDocument.name}.$typeImage';
      await storageRepository.saveFile(
        xFile: xFile,
        namePath: userDocument.pathStorage ?? "",
      );

      await firestore.collection("documents").doc().set(userDocument.toMap());

      return const Right(null);
    } catch (e) {
      return Left(ExceptionMessage('Erro ao enviar KYC: ${e.toString()}'));
    }
  }
}
