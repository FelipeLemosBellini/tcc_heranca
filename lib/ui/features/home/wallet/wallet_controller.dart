import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/ui/features/home/home_controller.dart';

class WalletController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();

  void loadAssets() {
    _homeController.setLoading(true);
    Future.delayed(Duration(seconds: 1));
    _homeController.setLoading(false);
  }
}
