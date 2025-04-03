import 'package:get_it/get_it.dart';
import 'package:tcc/Enum/enum_prove_of_live_recorrence.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';

class ProveOfLiveStepController extends BaseController {
  TestamentController testamentController = GetIt.I.get<TestamentController>();

  void setProveOfLiveRecorrence(EnumProveOfLiveRecorrence value) {
    testamentController.setProveOfLiveRecorrence(value);
  }
}