import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/kyc_model.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository_interface.dart';

class KycRepository implements KycRepositoryInterface {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _docRef() {
    final uid = firebaseAuth.currentUser?.uid;
    return firestore.collection('kyc').doc(uid);
  }

  @override
  Future<Either<ExceptionMessage, KycModel?>> getCurrent() async {
    try {
      final doc = await _docRef().get();
      if (!doc.exists) return const Right(null);
      final data = doc.data();
      if (data == null) return const Right(null);
      return Right(KycModel.fromMap(data));
    } catch (e) {
      return Left(ExceptionMessage('Erro ao carregar KYC: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> saveDraft(KycModel model) async {
    try {
      await _docRef().set(model.toMap(), SetOptions(merge: true));
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMessage('Erro ao salvar rascunho: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> submit(KycModel model) async {
    try {
      await _docRef().set(model.toMap(), SetOptions(merge: true));
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMessage('Erro ao enviar KYC: ${e.toString()}'));
    }
  }
}

