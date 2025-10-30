import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository_interface.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository.dart';

class KycRepository implements KycRepositoryInterface {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final StorageRepository storageRepository;

  KycRepository({required this.storageRepository});

  DocumentReference<Map<String, dynamic>> _docRef() {
    final uid = firebaseAuth.currentUser?.uid;
    return firestore.collection('documents').doc(uid);
  }

  @override
  Future<Either<ExceptionMessage, Document?>> getCurrent() async {
    try {
      final doc = await _docRef().get();
      if (!doc.exists) return const Right(null);
      final data = doc.data();
      if (data == null) return const Right(null);
      return Right(Document.fromMap(data));
    } catch (e) {
      return Left(ExceptionMessage('Erro ao carregar KYC: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> submit({
    required Document userDocument,
    required XFile xFile,
  }) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }
      userDocument.id = uid;
      userDocument.idDocument = uid;

      String typeImage = xFile.path.split('.').last;
      userDocument.pathStorage =
          'users/$uid/documents/${userDocument.typeDocument.name}.$typeImage';
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

  Future<Either<ExceptionMessage, KycStatus>> getStatusKyc() async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      DocumentSnapshot<Map<String, dynamic>>? response =
          await firestore.collection("users").doc(uid).get();
      late UserModel userModel;
      if (response.exists) {
        userModel = UserModel.fromMap(response.data()!);
      }

      return Right(userModel.kycStatus);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar o status do Kyc."));
    }
  }

  Future<Either<ExceptionMessage, void>> setStatusKyc({
    required KycStatus kycStatus,
    required String cpf,
    required String rg,
  }) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      DocumentSnapshot<Map<String, dynamic>>? response =
          await firestore.collection("users").doc(uid).get();
      late UserModel userModel;
      if (response.exists) {
        userModel = UserModel.fromMap(response.data()!);
      }
      userModel.kycStatus = kycStatus;
      userModel.cpf = cpf;
      userModel.rg = rg;
      await firestore.collection('users').doc(uid).update(userModel.toMap());

      return Right(userModel.kycStatus);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar o status do Kyc."));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByUserId({
    required String userId,
  }) async {
    try {
      final response =
          await firestore
              .collection('documents')
              .where('idDocument', isEqualTo: userId)
              .where('reviewStatus', isEqualTo: ReviewStatusDocument.pending.name)
              .get();
      final docs =
          response.docs.map((doc) {
            return Document.fromMap(doc.data())..idDocument = doc.id;
          }).toList();

      return Right(docs);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar os documentos"));
    }
  }

  @override
  Future<Either<ExceptionMessage, Document>> getDocumentById({
    required String docId,
  }) async {
    try {
      final response = await firestore.collection('documents').doc(docId).get();
      final doc = Document.fromMap(response.data()!);
      return Right(doc);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar o documento"));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> updateDocument({
    required String docId,
    required ReviewStatusDocument reviewStatus,
    String? reason,
  }) async {
    try {
      await firestore.collection('documents').doc(docId).update({
        'reviewStatus': reviewStatus.name,
        'updatedAt': DateTime.now(),
        'reason': reason,
      });
      return const Right(null);
    } catch (e) {
      return Left(
        ExceptionMessage("Erro ao atualizar o documento: ${e.toString()}"),
      );
    }
  }
}
