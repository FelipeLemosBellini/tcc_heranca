import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/kyc_model.dart';

abstract class KycRepositoryInterface {
  Future<Either<ExceptionMessage, void>> saveDraft(KycModel model);
  Future<Either<ExceptionMessage, void>> submit(KycModel model);
  Future<Either<ExceptionMessage, KycModel?>> getCurrent();
}

