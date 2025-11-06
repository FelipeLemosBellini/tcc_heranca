import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/constants/db_tables.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/repositories/kyc/kyc_repository_interface.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository_interface.dart';

class KycRepository implements KycRepositoryInterface {
  final SupabaseClient _client = Supabase.instance.client;

  final StorageRepositoryInterface storageRepository;

  KycRepository({required this.storageRepository});

  @override
  Future<Either<ExceptionMessage, Document?>> getCurrent() async {
    try {
      final uid = _client.auth.currentUser?.id;
      if (uid == null) return const Right(null);

      final fluxId = DbMappings.fluxToId(EnumDocumentsFrom.kyc)!;

      final response =
          await _client
              .from(DbTables.documents)
              .select()
              .eq('idUser', uid)
              .eq('numFlux', fluxId)
              .order('createdAt', ascending: false)
              .limit(1);

      if (response == null || response.isEmpty) return const Right(null);

      return Right(Document.fromMap(response.first));
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
      final uid = _client.auth.currentUser?.id;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }
      final now = DateTime.now();
      final extension = xFile.path.split('.').last;
      final storagePath =
          'users/$uid/documents/${userDocument.typeDocument.name}_${now.millisecondsSinceEpoch}.$extension';

      userDocument
        ..ownerId = uid
        ..idDocument = null
        ..pathStorage = storagePath
        ..from = userDocument.from ?? EnumDocumentsFrom.kyc;

      final saveResult = await storageRepository.saveFile(
        xFile: xFile,
        namePath: storagePath,
      );

      return await saveResult.fold(
        (error) async => Left(error),
        (_) async {
          final payload = userDocument.toMap()
            ..remove('id')
            ..putIfAbsent('createdAt', () => now.toIso8601String());

          await _client.from(DbTables.documents).insert(payload);
          return const Right(null);
        },
      );

    } catch (e) {
      return Left(ExceptionMessage('Erro ao enviar KYC: ${e.toString()}'));
    }
  }

  @override
  Future<Either<ExceptionMessage, KycStatus>> getStatusKyc() async {
    try {
      final uid = _client.auth.currentUser?.id;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }

      final response =
          await _client
              .from(DbTables.users)
              .select('numKycStatus')
              .eq('id', uid)
              .maybeSingle();

      final status = DbMappings.kycStatusFromId(response?['numKycStatus'] as int?);
      return Right(status);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao pegar o status do Kyc."));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> setStatusKyc({
    required KycStatus kycStatus,
    required String cpf,
    required String rg,
  }) async {
    try {
      final uid = _client.auth.currentUser?.id;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }

      final cleanCpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
      final cleanRg = rg.trim();

      if (cleanCpf.isEmpty || cleanRg.isEmpty) {
        return Left(ExceptionMessage("CPF e RG são obrigatórios."));
      }

      final cpfQuery =
          await _client
              .from(DbTables.users)
              .select('id')
              .eq('cpf', cleanCpf)
              .neq('id', uid);

      final cpfAlreadyUsed = cpfQuery.isNotEmpty;

      if (cpfAlreadyUsed) {
        return Left(
          ExceptionMessage('Este CPF já está em uso por outra conta.'),
        );
      }

      final rgQuery =
          await _client
              .from(DbTables.users)
              .select('id')
              .eq('rg', cleanRg)
              .neq('id', uid);

      final rgAlreadyUsed = rgQuery.isNotEmpty;

      if (rgAlreadyUsed) {
        return Left(
          ExceptionMessage('Este RG já está em uso por outra conta.'),
        );
      }

      await _client
          .from(DbTables.users)
          .update({
            'numKycStatus': DbMappings.kycStatusToId(kycStatus),
            'cpf': cleanCpf,
            'rg': cleanRg,
            'updatedAt': DateTime.now().toIso8601String(),
          })
          .eq('id', uid);

      return Right(kycStatus);
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
          await _client
              .from(DbTables.documents)
              .select()
              .eq('idUser', userId)
              .eq('numStatus', DbMappings.documentStatusToId(ReviewStatusDocument.pending));

      final docs = response.map((doc) => Document.fromMap(doc)).toList();

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
      final response =
          await _client
              .from(DbTables.documents)
              .select()
              .eq('id', docId)
              .maybeSingle();
      if (response == null) {
        return Left(ExceptionMessage("Documento não encontrado"));
      }
      final doc = Document.fromMap(response);
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
      await _client
          .from(DbTables.documents)
          .update({
            'numStatus': DbMappings.documentStatusToId(reviewStatus),
            'reviewMessage': reason,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', docId);
      return const Right(null);
    } catch (e) {
      return Left(
        ExceptionMessage("Erro ao atualizar o documento: ${e.toString()}"),
      );
    }
  }
}
