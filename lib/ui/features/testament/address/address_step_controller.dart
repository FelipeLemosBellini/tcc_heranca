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
  List<TextEditingController> amountControllers = [];
  List<FocusNode> focusNodes = [];

  int counterAmount = 0;

  void initController(FlowTestamentEnum flow) {
    if (flow == FlowTestamentEnum.edit) {
      TestamentModel testamentModel = testamentController.testament;
      for (HeirModel heirModel in testamentModel.listHeir) {
        addressControllers.add(TextEditingController(text: heirModel.address));
        amountControllers.add(TextEditingController(text: heirModel.percentage.toString()));
        amountControllers.last.addListener(checkAllFieldsUnfocused);
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
    amountControllers.add(TextEditingController());
    focusNodes.add(FocusNode());
    amountControllers.last.addListener(checkAllFieldsUnfocused);
    notifyListeners();
  }

  void removeField(int index) {
    addressControllers.removeAt(index);
    amountControllers.removeAt(index);
    focusNodes.removeAt(index);
    notifyListeners();
  }

  void checkAllFieldsUnfocused() {
    int count = 0;

    for (TextEditingController controller in amountControllers) {
      if (controller.text != '') {
        count += int.parse(controller.text);
      }
    }
    counterAmount = count;
    notifyListeners();
  }
}
