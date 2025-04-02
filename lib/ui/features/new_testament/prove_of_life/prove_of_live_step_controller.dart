import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';

class ProveOfLiveStepController extends BaseController {
  TestamentController testamentController = GetIt.I.get<TestamentController>();

  void setProveOfLive(DateTime value) {
    testamentController.setDateLastProveOfLife(value);
  }
}