import 'package:get_it/get_it.dart';
import 'package:tcc/Enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/ui/features/testament/widgets/flow_testament_enum.dart';

class ProveOfLiveStepController extends BaseController {
  TestamentController testamentController = GetIt.I.get<TestamentController>();

  String? selectedOption;

  void initController(FlowTestamentEnum flow) {
    if (flow == FlowTestamentEnum.edit) {
      switch (testamentController.testament.proveOfLiveRecorrence) {
        case EnumProveOfLiveRecorrence.TRIMESTRAL:
          selectedOption = 'Trimestral';
        case EnumProveOfLiveRecorrence.SEMESTRAL:
          selectedOption = 'Semestral';
        case EnumProveOfLiveRecorrence.ANUAL:
          selectedOption = 'Anual';

        // 'Trimestral', 'Semestral', 'Anual'
      }
    } else {
      selectedOption = null;
    }
  }

  void setProveOfLiveRecorrence(EnumProveOfLiveRecorrence value) {
    testamentController.setProveOfLiveRecorrence(value);
  }
}
