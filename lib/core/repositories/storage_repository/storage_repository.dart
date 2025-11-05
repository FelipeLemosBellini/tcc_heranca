import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/repositories/storage_repository/storage_repository_interface.dart';

class StorageRepository implements StorageRepositoryInterface {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Either<ExceptionMessage, void>> saveFile({
    required XFile xFile,
    required String namePath,
  }) async {
    try {
      final uid = firebaseAuth.currentUser?.uid;
      if (uid == null) {
        return Left(ExceptionMessage("Erro ao salvar imagem"));
      }
      final ref = FirebaseStorage.instance.ref(namePath);

      File file = File(xFile.path);
      String typeImage = xFile.path.split('.').last;
      ref.putFile(file, SettableMetadata(contentType: 'image/$typeImage'));
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage("Erro ao salvar imagem"));
    }
  }

  @override
  Future<File?> getFile({required String path}) async {
    final ref = FirebaseStorage.instance.ref(path);
    final tempDir = await getTemporaryDirectory();
    final localFile = File('${tempDir.path}/${ref.name}');
    await ref.writeToFile(localFile);
    return (localFile);
  }
}
