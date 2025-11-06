import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/constants/db_tables.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository_interface.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository_interface.dart';

class InheritanceCreationResult {
  final String inheritanceId;
  final String requesterId;
  final String testatorId;

  InheritanceCreationResult({
    required this.inheritanceId,
    required this.requesterId,
    required this.testatorId,
  });
}

class InheritanceRepository implements InheritanceRepositoryInterface {
  final SupabaseClient _client = Supabase.instance.client;

  final StorageRepositoryInterface storageRepository;

  InheritanceRepository({required this.storageRepository});

  @override
  Future<Either<ExceptionMessage, InheritanceCreationResult>> createInheritance(
    RequestInheritanceModel requestInheritanceModel,
  ) async {
    try {
      final uid = _client.auth.currentUser?.id;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }

      requestInheritanceModel.requestById = uid;

      final cleanCpf = (requestInheritanceModel.cpf ?? '').replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );

      final userResponse =
          await _client
              .from(DbTables.users)
              .select()
              .eq('cpf', cleanCpf)
              .limit(1)
              .maybeSingle();

      if (userResponse == null) {
        return Left(
          ExceptionMessage(
            "Não encontramos nenhum usuário com o CPF informado.",
          ),
        );
      }

      final testatorId = (userResponse['id'] as String?) ?? '';
      final user = UserModel.fromMap({
        ...userResponse,
        'id': testatorId,
      });

      requestInheritanceModel
        ..userId = testatorId
        ..name = user.name
        ..cpf = cleanCpf
        ..rg = user.rg
        ..heirStatus ??= HeirStatus.consultaSaldoSolicitado;

      final now = DateTime.now();
      final payload = requestInheritanceModel.toMap()
        ..remove('id')
        ..remove('createdAt')
        ..remove('updatedAt')
        ..putIfAbsent('cpf', () => cleanCpf)
        ..putIfAbsent('createdAt', () => now.toIso8601String())
        ..putIfAbsent('updatedAt', () => now.toIso8601String());

      final insertResponse =
          await _client
              .from(DbTables.inheritance)
              .insert(payload)
              .select('id')
              .single();

      final inheritanceId = insertResponse['id'] as String;

      return Right(
        InheritanceCreationResult(
          inheritanceId: inheritanceId,
          requesterId: uid,
          testatorId: testatorId,
        ),
      );
    } catch (e) {
      return Left(ExceptionMessage('Erro ao criar herança: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> submit({
    required Document document,
    required XFile xFile,
    required String inheritanceId,
    required String requesterId,
    required String testatorId,
  }) async {
    try {
      final now = DateTime.now();
      final extension = xFile.path.split('.').last;
      final storagePath =
          'inheritance/$inheritanceId/documents/${document.typeDocument.name}_${now.millisecondsSinceEpoch}.$extension';

      document
        ..ownerId = requesterId
        ..idDocument = null
        ..testatorId = testatorId
        ..pathStorage = storagePath
        ..from = EnumDocumentsFrom.inheritanceRequest;

      final saveResult = await storageRepository.saveFile(
        xFile: xFile,
        namePath: storagePath,
      );

      return await saveResult.fold(
        (error) async => Left(error),
        (_) async {
          final payload = document.toMap()
            ..remove('id')
            ..putIfAbsent('idUser', () => requesterId)
            ..remove('createdAt')
            ..putIfAbsent('createdAt', () => now.toIso8601String());

          await _client.from(DbTables.documents).insert(payload);

          await _client
              .from(DbTables.inheritance)
              .update({'updatedAt': now.toIso8601String()})
              .eq('id', inheritanceId);

          return const Right(null);
        },
      );
    } catch (e) {
      return Left(ExceptionMessage('Erro ao enviar documento: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ExceptionMessage, List<RequestInheritanceModel>>>
  getInheritancesByUserId() async {
    try {
      final uid = _client.auth.currentUser?.id;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }

      final response =
          await _client
              .from(DbTables.inheritance)
              .select()
              .eq('requestBy', uid);

      final inheritances =
          response.map((row) {
            return RequestInheritanceModel.fromMap({
              ...row,
              'id': row['id'],
              'createdAt': row['createdAt'],
              'updatedAt': row['updatedAt'],
            });
          }).toList();

      inheritances.sort((a, b) {
        final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return dateB.compareTo(dateA);
      });

      return Right(inheritances);
    } catch (e) {
      return Left(ExceptionMessage('Erro ao buscar heranças: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> updateStatus({
    required String inheritanceId,
    required HeirStatus status,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final payload = <String, dynamic>{
        'status': DbMappings.heirStatusToId(status),
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (additionalData != null && additionalData.isNotEmpty) {
        payload.addAll(additionalData);
      }
      await _client
          .from(DbTables.inheritance)
          .update(payload)
          .eq('id', inheritanceId);
      return const Right(null);
    } catch (e) {
      return Left(
        ExceptionMessage('Erro ao atualizar status: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByInheritance({
    required String requesterId,
    required String testatorId,
  }) async {
    try {
      final response =
          await _client
              .from(DbTables.documents)
              .select()
              .eq('idUser', requesterId)
              .eq('testatorId', testatorId)
              .eq('numFlux', DbMappings.fluxToId(EnumDocumentsFrom.inheritanceRequest)!);

      final documents =
          response.map((row) => Document.fromMap(row)).toList()
            ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

      return Right(documents);
    } catch (e) {
      return Left(
        ExceptionMessage('Erro ao buscar documentos: ${e.toString()}'),
      );
    }
  }
}
