import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcc/core/constants/db_tables.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository_interface.dart';

class StorageRepository implements StorageRepositoryInterface {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<Either<ExceptionMessage, void>> saveFile({
    required XFile xFile,
    required String namePath,
  }) async {
    try {
      if (_client.auth.currentUser == null) {
        return Left(ExceptionMessage("Erro ao salvar imagem"));
      }

      final bytes = await xFile.readAsBytes();
      final typeImage = xFile.path.split('.').last;

      await _client.storage
          .from(DbStorageBuckets.documents)
          .uploadBinary(
            namePath,
            bytes,
            fileOptions: FileOptions(
              contentType: 'content/$typeImage',
              upsert: true,
            ),
          );
      return const Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao salvar imagem: ${e.toString()}"));
    }
  }

  @override
  Future<File?> getFile({required String path}) async {
    try {
      final bytes =
          await _client.storage.from(DbStorageBuckets.documents).download(path);
      final tempDir = await getTemporaryDirectory();
      final fileName = path.split('/').last;
      final localFile = File('${tempDir.path}/$fileName');
      await localFile.writeAsBytes(bytes);
      return localFile;
    } catch (_) {
      return null;
    }
  }
}
