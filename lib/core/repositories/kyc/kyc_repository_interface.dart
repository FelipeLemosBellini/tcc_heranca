import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/user_document.dart';

abstract class KycRepositoryInterface {
  Future<Either<ExceptionMessage, void>> submit({
    required UserDocument userDocument,
    required XFile xFile,
  });

  Future<Either<ExceptionMessage, UserDocument?>> getCurrent();

  Future<Either<ExceptionMessage, List<UserDocument>>> getDocumentsByUserId({
    required String userId,
  });

  Future<Either<ExceptionMessage, UserDocument>> getDocumentById({
    required String docId,
  });

  Future<Either<ExceptionMessage, void>> updateDocument({
    required String docId,
    required ReviewStatusDocument reviewStatus,
  });
}
