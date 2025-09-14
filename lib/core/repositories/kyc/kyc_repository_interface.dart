import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/kyc_model.dart';

abstract class KycRepositoryInterface {
  Future<Either<ExceptionMessage, void>> submit({
    required UserDocument userDocument,
    required XFile xFile,
  });

  Future<Either<ExceptionMessage, UserDocument?>> getCurrent();
}
