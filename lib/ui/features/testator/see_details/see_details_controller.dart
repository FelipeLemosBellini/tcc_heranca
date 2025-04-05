import 'package:get_it/get_it.dart';
import 'package:tcc/core/controllers/testament_controller.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';

class SeeDetailsController extends BaseController {
  final TestamentController _testamentController = GetIt.I.get<TestamentController>();

  void setCurrentTestament(TestamentModel testament) {
    _testamentController.setTestamentToEdit(testament);
  }
}
