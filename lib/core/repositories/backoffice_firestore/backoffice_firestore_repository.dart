import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/testator_summary.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';

class BackofficeFirestoreRepository implements BackofficeFirestoreInterface {
  final FirebaseFirestore _firestore;

  BackofficeFirestoreRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<ExceptionMessage, List<UserModel>>> getUsersPendentes({
    EnumDocumentsFrom? from,
  }) async {
    try {
      var query = _firestore
          .collection('documents')
          .where(
            'reviewStatus',
            isEqualTo: ReviewStatusDocument.pending.name,
          );

      if (from != null) {
        query = query.where('from', isEqualTo: from.name);
      }

      final pendingDocs = await query.get();

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
    String? testatorCpf,
    EnumDocumentsFrom? from,
  }) async {
    try {
      var query = _firestore
          .collection('documents')
          .where('idDocument', isEqualTo: userId)
          .where('reviewStatus', isEqualTo: ReviewStatusDocument.pending.name);

      if (from != null) {
        query = query.where('from', isEqualTo: from.name);
      }

      final response = await query.get();
      var docs = response.docs.map((doc) {
        return Document.fromMap(doc.data())..idDocument = doc.id;
      }).toList();

      if (testatorCpf != null && testatorCpf.isNotEmpty) {
        docs = docs.where((doc) => doc.content == testatorCpf).toList();
      }

      return Right(docs);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar os documentos"));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<TestatorSummary>>> getTestatorsByRequester({
    required String requesterId,
  }) async {
    try {
      final documentsSnapshot =
          await _firestore
              .collection('documents')
              .where('idDocument', isEqualTo: requesterId)
              .where('reviewStatus', isEqualTo: ReviewStatusDocument.pending.name)
              .where('from', isEqualTo: EnumDocumentsFrom.inheritanceRequest.name)
              .get();

      final cpfs = documentsSnapshot.docs
          .map((doc) => (doc.data()['content'] as String?)?.trim())
          .whereType<String>()
          .where((cpf) => cpf.isNotEmpty)
          .toSet()
          .toList();

      if (cpfs.isEmpty) {
        return right([]);
      }

      final usersByCpf = <String, UserModel>{};
      const chunkSize = 10;

      for (var i = 0; i < cpfs.length; i += chunkSize) {
        final chunk = cpfs.sublist(
          i,
          i + chunkSize > cpfs.length ? cpfs.length : i + chunkSize,
        );

        final usersSnapshot =
            await _firestore
                .collection('users')
                .where('cpf', whereIn: chunk)
                .get();

        for (final userDoc in usersSnapshot.docs) {
          final data = userDoc.data();
          final user = UserModel.fromMap({
            ...data,
            'id': userDoc.id,
          });
          if (user.cpf != null && user.cpf!.isNotEmpty) {
            usersByCpf[user.cpf!] = user;
          }
        }
      }

      final summaries = cpfs.map((cpf) {
        final user = usersByCpf[cpf];
        if (user != null) {
          return TestatorSummary(cpf: cpf, name: user.name, userId: user.id);
        }
        return TestatorSummary(cpf: cpf, name: cpf, userId: null);
      }).toList();

      return right(summaries);
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

  @override
  Future<Either<ExceptionMessage, void>> updateInheritanceStatus({
    required String requesterId,
    required String testatorCpf,
    required HeirStatus status,
  }) async {
    try {
      final query = await _firestore
          .collection('inheritance')
          .where('requestById', isEqualTo: requesterId)
          .where('cpf', isEqualTo: testatorCpf)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return left(
          ExceptionMessage('Processo de herança não encontrado para atualização.'),
        );
      }

      await query.docs.first.reference.update({
        'heirStatus': status.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } catch (e) {
      return left(ExceptionMessage('Erro ao atualizar status da herança: $e'));
    }
  }
}
