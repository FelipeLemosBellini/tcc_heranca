import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class TestatorController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();

  TestatorController();

  double balance = 0.0;

  void getBalance() {
    balance = 1;
    notifyListeners();
  }
}
