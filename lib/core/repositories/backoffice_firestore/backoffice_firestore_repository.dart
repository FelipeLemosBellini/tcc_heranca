import 'package:fpdart/fpdart.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/constants/db_tables.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/environment/env.dart';
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
      final pendingStatusId = DbMappings.documentStatusToId(
        ReviewStatusDocument.pending,
      );
      final fluxId = DbMappings.fluxToId(from);

      var documentsQuery = _client
          .from(DbTables.documents)
          .select('idUser')
          .eq('numStatus', pendingStatusId);

      if (fluxId != null) {
        documentsQuery = documentsQuery.eq('numFlux', fluxId);
      }

      final documentsResponse = await documentsQuery;

      final userIds =
          documentsResponse
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

        final snapshot = await _client
            .from(DbTables.users)
            .select()
            .inFilter('id', chunk);

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
    String? testatorId,
    EnumDocumentsFrom? from,
    bool onlyPending = true,
  }) async {
    try {
      var query = _client
          .from(DbTables.documents)
          .select()
          .eq('idUser', userId);

      if (onlyPending) {
        query = query.eq(
          'numStatus',
          DbMappings.documentStatusToId(ReviewStatusDocument.pending),
        );
      }

      if (from != null) {
        query = query.eq('numFlux', DbMappings.fluxToId(from)!);
      }

      if (testatorId != null && testatorId.isNotEmpty) {
        query = query.eq('testatorId', testatorId);
      }

      final response = await query;
      var docs = response.map((row) => Document.fromMap(row)).toList();

      return Right(docs);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar os documentos: $e"));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<TestatorSummary>>>
  getTestatorsByRequester({required String requesterId}) async {
    try {
      final pendingStatusId = DbMappings.documentStatusToId(
        ReviewStatusDocument.pending,
      );
      final inheritanceFluxId =
          DbMappings.fluxToId(EnumDocumentsFrom.inheritanceRequest)!;

      final docs = await _client
          .from(DbTables.documents)
          .select('testatorId')
          .eq('idUser', requesterId)
          .eq('numStatus', pendingStatusId)
          .eq('numFlux', inheritanceFluxId);

      final testatorIdSet = <String>{};
      final orderedIds = <String>[];

      for (final doc in docs) {
        final id = (doc['testatorId'] as String?)?.trim();
        if (id != null && id.isNotEmpty) {
          if (testatorIdSet.add(id)) {
            orderedIds.add(id);
          }
        }
      }

      if (testatorIdSet.isEmpty) {
        return right([]);
      }

      final usersById = <String, UserModel>{};
      const chunkSize = 50;

      for (var i = 0; i < orderedIds.length; i += chunkSize) {
        final chunk = orderedIds.sublist(
          i,
          i + chunkSize > orderedIds.length ? orderedIds.length : i + chunkSize,
        );

        final usersSnapshot = await _client
            .from(DbTables.users)
            .select()
            .inFilter('id', chunk);

        for (final raw in usersSnapshot) {
          final user = UserModel.fromMap(raw);
          if ((user.id ?? '').isNotEmpty) {
            usersById[user.id!] = user;
          }
        }
      }

      final summaries =
          orderedIds.map((id) {
            final user = usersById[id];
            if (user != null) {
              return TestatorSummary(
                cpf: user.cpf ?? '',
                name: user.name,
                userId: user.id,
              );
            }
            return TestatorSummary(cpf: '', name: id, userId: id);
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
    String? reason,
  }) async {
    try {
      final statusEnum =
          status ? ReviewStatusDocument.approved : ReviewStatusDocument.invalid;
      await _client
          .from(DbTables.documents)
          .update({
            'numStatus': DbMappings.documentStatusToId(statusEnum),
            'updatedAt': DateTime.now().toIso8601String(),
            'reviewMessage': reason,
          })
          .eq('id', documentId);
      return right(null);
    } catch (e) {
      return left(ExceptionMessage('Erro ao atualizar documento: $e'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> updateStatusUser({
    required bool hasInvalidDocument,
    required String userId,
  }) async {
    try {
      KycStatus status =
          hasInvalidDocument ? KycStatus.rejected : KycStatus.approved;
      await _client
          .from(DbTables.users)
          .update({
            'numKycStatus': DbMappings.kycStatusToId(status),
            'updatedAt': DateTime.now().toIso8601String(),
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
    required String testatorId,
    required HeirStatus status,
  }) async {
    try {
      final record =
          await _client
              .from(DbTables.inheritance)
              .select('id')
              .eq('requestBy', requesterId)
              .eq('testatorId', testatorId)
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
            'updatedAt': DateTime.now().toIso8601String(),
          })
          .eq('id', record['id']);

      return const Right(null);
    } catch (e) {
      return left(ExceptionMessage('Erro ao atualizar status da herança: $e'));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<RequestInheritanceModel>>>
  getCompletedInheritances() async {
    try {
      final completedStatus = DbMappings.heirStatusToId(
        HeirStatus.transferenciaSaldoRealizada,
      );

      final snapshot = await _client
          .from(DbTables.inheritance)
          .select('*, users:users!inner(name, cpf, rg)')
          .eq('status', completedStatus);

      final inheritances =
          snapshot.map((row) {
            return RequestInheritanceModel.fromMap({
              ...row,
              'createdAt': row['createdAt'],
              'updatedAt': row['updatedAt'],
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

  @override
  Future<Either<ExceptionMessage, void>> sendEmailWithBalance({
    required String balance,
    required String requestUserId,
  }) async {
    try {
      final response =
          await _client
              .from(DbTables.inheritance)
              .select('id, email')
              .eq('requestBy', requestUserId)
              .limit(1)
              .maybeSingle();

      final String keyEmail = Env.keyEmail;
      final String gmailUser = 'felipelemosbellini@gmail.com';

      final smtpServer = gmail(gmailUser, keyEmail);

      final message =
          Message()
            ..from = Address(gmailUser, 'Ethernium App')
            ..recipients.add(response?['email'])
            ..subject = 'Assunto de teste'
            ..text = 'Corpo em texto';

      try {
        final sendReport = await send(message, smtpServer);
        print('Enviado: ${sendReport.toString()}');
      } on MailerException catch (e) {
        for (final p in e.problems) {
          print('Problema: ${p.code}: ${p.msg}');
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMessage('Erro ao enviar email: $e'));
    }
  }
}
