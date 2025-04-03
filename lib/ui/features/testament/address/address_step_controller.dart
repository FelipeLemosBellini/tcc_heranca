import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/heir_model.dart';
import 'package:tcc/core/models/testament_model.dart';

class AddressStepController extends BaseController {
  TestamentController testamentController = GetIt.I.get<TestamentController>();

  void setListHeir(List<HeirModel> listHeir) {
    testamentController.setListHeir(listHeir);
  }
}
