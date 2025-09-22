import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';

class RequestInheritanceController extends BaseController {
  final FirestoreRepository firestoreRepository;


  RequestInheritanceController({required this.firestoreRepository});

  Future<void> createRequestInheritance({
    required String cpf,
    required String rg,
    required XFile procuracaoAdogado,
    required XFile proofResidence,
  }) async {

  }
}
