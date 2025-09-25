import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';

class RequestVaultController extends BaseController {
  final FirestoreRepository firestoreRepository;

  TextEditingController cpfHeirController = TextEditingController();
  TextEditingController cpfTestatorController = TextEditingController();

  FocusNode cpfHeirFocus = FocusNode();
  FocusNode cpfTestatorFocus = FocusNode();


  RequestVaultController({required this.firestoreRepository});

  Future<void> createRequestInheritance({
    required String cpfHeir,
    required String cpfTestator,
    required XFile certificadoDeObito,
    required XFile procuracaoAdvogado,
  }) async {

  }
}
