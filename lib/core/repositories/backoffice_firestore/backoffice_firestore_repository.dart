import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';

class BackofficeFirestoreRepository implements BackofficeFirestoreInterface {
  final FirebaseFirestore _firestore;

  BackofficeFirestoreRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<ExceptionMessage, List<UserModel>>> getUsersPendentes() async {
    try {
      final pendingDocs =
          await _firestore
              .collection('documents')
              .where(
                'reviewStatus',
                isEqualTo: ReviewStatusDocument.pending.name,
              )
              .get();

      final userIds =
          pendingDocs.docs
              .map((doc) => doc.data()['idDocument'] as String?)
              .whereType<String>()
              .toSet()
              .toList();

      if (userIds.isEmpty) return right([]);

      final users = <UserModel>[];
      const chunkSize = 10;

      for (var i = 0; i < userIds.length; i += chunkSize) {
        final chunk = userIds.sublist(
          i,
          i + chunkSize > userIds.length ? userIds.length : i + chunkSize,
        );
        final usersSnapshot =
            await _firestore
                .collection('users')
                .where(FieldPath.documentId, whereIn: chunk)
                .get();

        users.addAll(
          usersSnapshot.docs.map((userDoc) {
            final data = userDoc.data();
            return UserModel.fromMap({
              ...data,
              'id': userDoc.id, // garante o id no modelo
            });
          }),
        );
      }

      return right(users);
    } catch (e) {
      return left(ExceptionMessage(e.toString()));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByUserId({
    required String userId,
  }) async {
    try {
      final response =
      await _firestore
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

  @override
  Future<Either<ExceptionMessage, void>> updateStatusUser({
    required bool hasInvalidDocument,
    required String userId,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'kycStatus': hasInvalidDocument ? "reproved" : "approved",
      });
      return const Right(null);
    } catch (e) {
      return Left(
        ExceptionMessage("Erro ao atualizar o documento: ${e.toString()}"),
      );
    }
  }
}
