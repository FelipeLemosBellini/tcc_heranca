import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/exceptions/exception_message.dart';

abstract class StorageRepositoryInterface {
  Future<Either<ExceptionMessage, void>> saveFile({
    required XFile xFile,
    required String namePath,
  });

  Future<File?> getFile({required String path});
}
