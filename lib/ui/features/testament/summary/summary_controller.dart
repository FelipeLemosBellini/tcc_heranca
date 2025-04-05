import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';

class SummaryController extends BaseController {
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

  void saveTestament(FlowTestamentEnum flow) {
    testamentController.setTitle(titleController.text);
    if (flow == FlowTestamentEnum.edit) {
      testamentController.updateTestament();
    } else {
      testamentController.saveTestament();
    }
  }

  void clearTestament() {
    testamentController.clearTestament();
  }
}
