import 'package:fpdart/fpdart.dart';
import 'package:tcc/core/exceptions/exception_message.dart';

abstract class FirestoreRepositoryInterface {
  Future<Either<ExceptionMessage, void>> getUser();
}
