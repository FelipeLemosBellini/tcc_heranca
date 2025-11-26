import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/enum/heir_status.dart';
import 'package:tcc/core/exceptions/exception_message.dart';
import 'package:tcc/core/models/document.dart';
import 'package:tcc/core/models/request_inheritance_model.dart';
import 'package:tcc/core/repositories/inheritance_repository/inheritance_repository.dart';

abstract class InheritanceRepositoryInterface {
  Future<Either<ExceptionMessage, InheritanceCreationResult>> createInheritance(
    RequestInheritanceModel requestInheritanceModel,
  );

  Future<Either<ExceptionMessage, void>> submit({
    required Document document,
    required XFile xFile,
    required String inheritanceId,
    required String requesterId,
    required String testatorId,
  });

  Future<Either<ExceptionMessage, List<RequestInheritanceModel>>>
  getInheritancesByUserId();

  Future<Either<ExceptionMessage, void>> updateStatus({
    required String inheritanceId,
    required HeirStatus status,
    Map<String, dynamic>? additionalData,
  });

  Future<Either<ExceptionMessage, List<Document>>> getDocumentsByInheritance({
    required String requesterId,
    required String testatorId,
  });

  Future<Either<ExceptionMessage, RequestInheritanceModel>>
  getInheritanceByUserIdAndTestatorId(String testatorId, String requestBy);
}
