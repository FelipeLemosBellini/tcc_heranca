import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';

abstract class KycRepositoryInterface {
  Future<Either<ExceptionMessage, void>> submit({
    required Document userDocument,
    required XFile xFile,
  });

  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByUserId();

  Future<Either<ExceptionMessage, Document>> getDocumentById({
    required String docId,
  });

  Future<Either<ExceptionMessage, void>> setStatusKyc({
    required KycStatus kycStatus,
    required String cpf,
    required String rg,
  });

  Future<Either<ExceptionMessage, KycStatus>> getStatusKyc();
}
