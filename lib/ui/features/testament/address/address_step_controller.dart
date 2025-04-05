import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';

class AddressStepController extends BaseController {
  TestamentController testamentController = GetIt.I.get<TestamentController>();

  List<TextEditingController> addressControllers = [];
  List<TextEditingController> percentageControllers = [];
  List<FocusNode> focusNodes = [];

  int counterPercentage = 0;

  void initController(FlowTestamentEnum flow) {
    if (flow == FlowTestamentEnum.edit) {
      TestamentModel testamentModel = testamentController.testament;
      for (HeirModel heirModel in testamentModel.listHeir) {
        addressControllers.add(TextEditingController(text: heirModel.address));
        percentageControllers.add(TextEditingController(text: heirModel.percentage.toString()));
        percentageControllers.last.addListener(checkAllFieldsUnfocused);
        focusNodes.add(FocusNode());
      }
      checkAllFieldsUnfocused();
    } else {
      addNewField();
    }
    notifyListeners();
  }

  void setListHeir(List<HeirModel> listHeir) {
    testamentController.setListHeir(listHeir);
  }

  void addNewField() {
    addressControllers.add(TextEditingController());
    percentageControllers.add(TextEditingController());
    focusNodes.add(FocusNode());
    percentageControllers.last.addListener(checkAllFieldsUnfocused);
    notifyListeners();
  }

  void removeField(int index) {
    addressControllers.removeAt(index);
    percentageControllers.removeAt(index);
    focusNodes.removeAt(index);
    notifyListeners();
  }

  void checkAllFieldsUnfocused() {
    int count = 0;

    for (TextEditingController controller in percentageControllers) {
      if (controller.text != '') {
        count += int.parse(controller.text);
      }
    }
    counterPercentage = count;
    notifyListeners();
  }
}
