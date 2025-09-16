import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_document.dart';
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
    return firestore.collection('user_documents').doc(uid);
  }

  @override
  Future<Either<ExceptionMessage, UserDocument?>> getCurrent() async {
    try {
      final doc = await _docRef().get();
      if (!doc.exists) return const Right(null);
      final data = doc.data();
      if (data == null) return const Right(null);
      return Right(UserDocument.fromMap(data));
    } catch (e) {
      return Left(ExceptionMessage('Erro ao carregar KYC: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> submit({
    required UserDocument userDocument,
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
          'users/$uid/documents/${userDocument.typeDocument.name}.$typeImage';
      await storageRepository.saveImage(
        xFile: xFile,
        namePath: userDocument.pathStorage ?? "",
      );

      firestore
          .collection('user_documents')
          .doc()
          .set(userDocument.toMap(), SetOptions(merge: true));

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
      await firestore.collection('users').doc(uid).update(userModel.toMap());

      return Right(userModel.kycStatus);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar o status do Kyc."));
    }
  }

  Future<Either<ExceptionMessage, List<UserDocument>>> getDocumentsByUserId({
    required String userId,
  }) async {
    try{
      final response = await firestore.collection('user_documents').where('id', isEqualTo: userId).get();
      final documents = response.docs.map((doc) => UserDocument.fromMap(doc.data())).toList();
      return Right(documents);
    } catch (e){
      return Left(ExceptionMessage("Erro ao pegar os documentos"));
    }
  }
}
