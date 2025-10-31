import 'package:get_it/get_it.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/models/testament_model.dart';
import 'package:tcc/core/models/user_model.dart';
import 'package:tcc/core/repositories/rpc_repository/rpc_repository.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class TestatorController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  final RpcRepository rpcRepository;

  TestatorController({required this.rpcRepository});

  double balance = 0.0;

  void getBalance() {
    // rpcRepository.getEthBalance('https://gas.api.infura.io/v3/3ab1afcb30cb40c3810a5fadfac719b6', '0x8f4B1115dfEddC02F8e2361Ac17D75B4D806d79d');
    notifyListeners();
  }
}
