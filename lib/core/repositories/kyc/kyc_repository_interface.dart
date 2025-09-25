import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';

abstract class KycRepositoryInterface {
  Future<Either<ExceptionMessage, void>> submit({
    required Document userDocument,
    required XFile xFile,
  });

  Future<Either<ExceptionMessage, Document?>> getCurrent();

  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByUserId({
    required String userId,
  });

  Future<Either<ExceptionMessage, Document>> getDocumentById({
    required String docId,
  });

  Future<Either<ExceptionMessage, void>> updateDocument({
    required String docId,
    required ReviewStatusDocument reviewStatus,
    String? reason,
  });
}
