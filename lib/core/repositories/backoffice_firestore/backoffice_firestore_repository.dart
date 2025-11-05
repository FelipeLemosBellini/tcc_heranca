import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/constants/db_tables.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/models/testator_summary.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/backoffice_firestore/backoffice_firestore_interface.dart';

class BackofficeFirestoreRepository implements BackofficeFirestoreInterface {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<Either<ExceptionMessage, List<UserModel>>> getUsersPendentes({
    EnumDocumentsFrom? from,
  }) async {
    try {
      final pendingStatusId =
          DbMappings.documentStatusToId(ReviewStatusDocument.pending);
      final fluxId = DbMappings.fluxToId(from);

      var query =
          _client.from(DbTables.documents).select('idUser').eq('numStatus', pendingStatusId);

      if (fluxId != null) {
        query = query.eq('numFlux', fluxId);
      }

      final pendingDocs = await query;

      final userIds =
          pendingDocs
              .map((doc) => doc['idUser'] as String?)
              .whereType<String>()
              .toSet()
              .toList();

      if (userIds.isEmpty) return right([]);

      final users = <UserModel>[];
      const chunkSize = 50;

      for (var i = 0; i < userIds.length; i += chunkSize) {
        final chunk = userIds.sublist(
          i,
          i + chunkSize > userIds.length ? userIds.length : i + chunkSize,
        );

        final snapshot =
            await _client.from(DbTables.users).select().inFilter('id', chunk);

        users.addAll(snapshot.map((raw) => UserModel.fromMap(raw)));
      }

      return right(users);
    } catch (e) {
      return left(ExceptionMessage('Erro ao buscar usuários pendentes: $e'));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByUserId({
    required String userId,
    String? testatorCpf,
    EnumDocumentsFrom? from,
    bool onlyPending = true,
  }) async {
    try {
      var query =
          _client.from(DbTables.documents).select().eq('idUser', userId);

      if (onlyPending) {
        query = query.eq(
          'numStatus',
          DbMappings.documentStatusToId(ReviewStatusDocument.pending),
        );
      }

      if (from != null) {
        query = query.eq('numFlux', DbMappings.fluxToId(from)!);
      }

      final response = await query;
      var docs = response.map((row) => Document.fromMap(row)).toList();

      if (testatorCpf != null && testatorCpf.isNotEmpty) {
        docs = docs.where((doc) => doc.content == testatorCpf).toList();
      }

      return Right(docs);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar os documentos: $e"));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<TestatorSummary>>> getTestatorsByRequester({
    required String requesterId,
  }) async {
    try {
      final pendingStatusId =
          DbMappings.documentStatusToId(ReviewStatusDocument.pending);
      final inheritanceFluxId =
          DbMappings.fluxToId(EnumDocumentsFrom.inheritanceRequest)!;

      final docs =
          await _client
              .from(DbTables.documents)
              .select('content')
              .eq('idUser', requesterId)
              .eq('numStatus', pendingStatusId)
              .eq('numFlux', inheritanceFluxId);

      final cpfs =
          docs
              .map((doc) => (doc['content'] as String?)?.trim())
              .whereType<String>()
              .where((value) => value.isNotEmpty)
              .toSet()
              .toList();

      if (cpfs.isEmpty) return right([]);

      final usersByCpf = <String, UserModel>{};
      const chunkSize = 50;

      for (var i = 0; i < cpfs.length; i += chunkSize) {
        final chunk = cpfs.sublist(
          i,
          i + chunkSize > cpfs.length ? cpfs.length : i + chunkSize,
        );

        final usersSnapshot =
            await _client.from(DbTables.users).select().inFilter('cpf', chunk);

        for (final raw in usersSnapshot) {
          final user = UserModel.fromMap(raw);
          if ((user.cpf ?? '').isNotEmpty) {
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
      return left(ExceptionMessage('Erro ao buscar testadores: $e'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> changeStatusDocument({
    required String documentId,
    required bool status,
  }) async {
    try {
      final statusEnum =
          status ? ReviewStatusDocument.approved : ReviewStatusDocument.invalid;
      await _client
          .from(DbTables.documents)
          .update({
            'numStatus': DbMappings.documentStatusToId(statusEnum),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', documentId);
      return right(null);
    } catch (e) {
      return left(ExceptionMessage('Erro ao atualizar documento: $e'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> changeStatusUser({
    required String userId,
    required bool status,
  }) async {
    try {
      final newStatus = status ? KycStatus.approved : KycStatus.rejected;
      await _client
          .from(DbTables.users)
          .update({
            'numKycStatus': DbMappings.kycStatusToId(newStatus),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      return right(null);
    } catch (e) {
      return left(ExceptionMessage('Erro ao atualizar status do usuário: $e'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> updateStatusUser({
    required bool hasInvalidDocument,
    required String userId,
  }) async {
    try {
      final status =
          hasInvalidDocument ? KycStatus.rejected : KycStatus.approved;
      await _client
          .from(DbTables.users)
          .update({
            'numKycStatus': DbMappings.kycStatusToId(status),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      return const Right(null);
    } catch (e) {
      return Left(
        ExceptionMessage("Erro ao atualizar o status do usuário: $e"),
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
      final record =
          await _client
              .from(DbTables.inheritance)
              .select('id')
              .eq('requestBy', requesterId)
              .eq('cpf', testatorCpf)
              .limit(1)
              .maybeSingle();

      if (record == null || record['id'] == null) {
        return left(
          ExceptionMessage(
            'Processo de herança não encontrado para atualização.',
          ),
        );
      }

      await _client
          .from(DbTables.inheritance)
          .update({
            'status': DbMappings.heirStatusToId(status),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', record['id']);

      return const Right(null);
    } catch (e) {
      return left(ExceptionMessage('Erro ao atualizar status da herança: $e'));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<RequestInheritanceModel>>> getCompletedInheritances() async {
    try {
      final completedStatus =
          DbMappings.heirStatusToId(HeirStatus.transferenciaSaldoRealizada);

      final snapshot =
          await _client
              .from(DbTables.inheritance)
              .select()
              .eq('status', completedStatus);

      final inheritances = snapshot.map((row) {
        return RequestInheritanceModel.fromMap({
          ...row,
          'createdAt': row['created_at'],
          'updatedAt': row['updated_at'],
        });
      }).toList();

      inheritances.sort(
        (a, b) => (b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0)),
      );

      return Right(inheritances);
    } catch (e) {
      return Left(
        ExceptionMessage('Erro ao carregar processos finalizados: $e'),
      );
    }
  }
}
