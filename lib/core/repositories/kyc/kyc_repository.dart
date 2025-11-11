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

      return await saveResult.fold((error) async => Left(error), (_) async {
        final payload =
            userDocument.toMap()
              ..remove('id')
              ..putIfAbsent('createdAt', () => now.toIso8601String());

        await _client.from(DbTables.documents).insert(payload);
        return const Right(null);
      });
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

      final status = DbMappings.kycStatusFromId(
        response?['numKycStatus'] as int?,
      );
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

      final cpfQuery = await _client
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

      final rgQuery = await _client
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
  Future<Either<ExceptionMessage, List<Document>>>
  getDocumentsByUserId() async {
    try {
      final uid = _client.auth.currentUser?.id;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao buscar usuário"));
      }

      final response = await _client
          .from(DbTables.documents)
          .select()
          .eq('idUser', uid);

      final docs = response.map((doc) => Document.fromMap(doc)).toList();

      if (docs.isEmpty) {
        return Right(<Document>[]);
      }

      final Map<DateTime, List<Document>> gruposPorMinuto = {};
      for (final d in docs) {
        final DateTime dt = d.uploadedAt;
        final key = DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
        (gruposPorMinuto[key] ??= <Document>[]).add(d);
      }

      final DateTime chaveMaisRecente = gruposPorMinuto.keys.reduce(
        (a, b) => a.isAfter(b) ? a : b,
      );

      final List<Document> grupoMaisRecente = List<Document>.from(
        gruposPorMinuto[chaveMaisRecente]!,
      );

      // Opcional: ordenar os docs do grupo por data decrescente
      grupoMaisRecente.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

      return Right(grupoMaisRecente);
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
}
