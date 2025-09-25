import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';

class BackofficeFirestoreRepository implements BackofficeFirestoreInterface {
  final FirebaseFirestore _firestore;

  BackofficeFirestoreRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<ExceptionMessage, List<UserModel>>> getUsers() async {
    try {
      final query =
          await _firestore
              .collection('users')
              .where("kycStatus", isEqualTo: KycStatus.submitted.name)
              .get();
      final users =
          query.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
      return Right(users);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByUserId({
    required String userId,
  }) async {
    try {
      final query =
          await _firestore
              .collection('documents')
              .where('userId', isEqualTo: userId)
              .get();
      final docs =
          query.docs.map((doc) {

            return Document.fromMap(doc.data())..idDocument = doc.id;
          }).toList();
      // Ajuste conforme seu modelo: se UserDocument encapsula uma lista, crie a instância apropriada.
      return right(docs);
    } catch (e) {
      return left(ExceptionMessage(e.toString()));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> changeStatusDocument({
    required String documentId,
    required bool status,
  }) async {
    try {
      await _firestore.collection('documents').doc(documentId).update({
        'reviewStatus': status,
      });
      return right(null);
    } catch (e) {
      return left(ExceptionMessage(e.toString()));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> changeStatusUser({
    required String userId,
    required bool status,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'kycStatus': status,
      });
      return right(null);
    } catch (e) {
      return left(ExceptionMessage(e.toString()));
    }
  }
}
