import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';

class AmountStepController extends BaseController {
  TestamentController testamentController = GetIt.I.get<TestamentController>();

  final TextEditingController _amountController = TextEditingController();

  TextEditingController get amountController => _amountController;

  void initController(FlowTestamentEnum flow) {
    if (flow == FlowTestamentEnum.edit) {
      _amountController.text = testamentController.testament.value.toString();
    }
  }

  void clearTestament() {
    testamentController.clearTestament();
  }

  void setAmount(double value) {
    testamentController.setValue(value);
  }
}
