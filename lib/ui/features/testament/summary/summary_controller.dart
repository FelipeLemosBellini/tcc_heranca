import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/firestore/firestore_repository.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class SummaryController extends BaseController {
  final FirestoreRepository firestoreRepository;

  SummaryController({required this.firestoreRepository});

  TestamentController testamentController = GetIt.I.get<TestamentController>();
  final TextEditingController titleController = TextEditingController();

  late TestamentModel testamentModel;

  void initController(FlowTestamentEnum flow) {
    if (flow == FlowTestamentEnum.edit) {
      titleController.text = testamentController.testament.title;
      notifyListeners();
    }
    testamentModel = testamentController.testament;
  }

  void saveTestament(FlowTestamentEnum flow) async {
    var response = await firestoreRepository.getUser();

    late UserModel userModel;
    response.fold(
      (error) {
        setMessage(
          AlertData(
            message: "Erro ao criar o testamento",
            errorType: ErrorType.error,
          ),
        );
        return;
      },
      (UserModel user) {
        userModel = user;
      },
    );
    testamentController.setTitle(titleController.text);
    if (flow == FlowTestamentEnum.edit) {
      await firestoreRepository.updateTestament(
        addressTestator: userModel.address,
        testament: testamentController.testament,
      );
      await firestoreRepository.updateBalance(
          userId: userModel.uid,
          balance: userModel.balance + testamentController.testament.value
      );
    } else {
      await firestoreRepository.createTestament(
        addressTestator: userModel.address,
        testament: testamentController.testament,
      );
      await firestoreRepository.updateBalance(
          userId: userModel.uid,
          balance: userModel.balance - testamentController.testament.value
      );
    }
    clearTestament();
    notifyListeners();
  }

  void clearTestament() {
    testamentController.clearTestament();
  }
}
