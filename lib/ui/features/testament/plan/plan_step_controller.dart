import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/enum/EnumPlan.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';

class PlanStepController extends BaseController {
  TestamentController testamentController = GetIt.I.get<TestamentController>();

  String? selectedOption;

  void initController(FlowTestamentEnum flow) {
    if (flow == FlowTestamentEnum.edit) {
      switch (testamentController.testament.plan) {
        case EnumPlan.TESTE:
          selectedOption = 'Teste';
        case EnumPlan.BASICO:
          selectedOption = 'Basico';
        case EnumPlan.PRO:
          selectedOption = 'Pro';
      }
    } else {
      selectedOption = null;
    }
  }

  void setPlan(EnumPlan value) {
    testamentController.setPlan(value);
  }

}
