import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';

class SummaryController extends BaseController {
  TestamentController testamentController = GetIt.I.get<TestamentController>();

  TestamentModel getTestament() {
   return testamentController.testament;
  }

  void saveTestament(TestamentModel testament) {
    testamentController.saveTestament(testament);
  }
}