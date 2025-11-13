import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:tcc/core/enum/connect_state_blockchain.dart';
import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/blockchain_repository/blockchain_repository.dart';
import 'package:tcc/core/repositories/user_repository/user_repository_interface.dart';
import 'package:tcc/ui/features/home/home_controller.dart';
import 'package:tcc/ui/widgets/dialogs/alert_helper.dart';

class TestatorController extends BaseController {
  final HomeController _homeController = GetIt.I.get<HomeController>();
  final UserRepositoryInterface userRepository;
  final BlockchainRepository blockchainRepository;

  TestatorController({
    required this.userRepository,
    required this.blockchainRepository,
  });

  ConnectStateBlockchain state = ConnectStateBlockchain.idle;
  StreamSubscription<ConnectStateBlockchain>? _sub;

  double balance = 0.0;

  bool? hasVault;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> init() async {
    final result = await blockchainRepository.watchState();
    result.fold(
      (err) {
        notifyListeners();
      },
      (stream) {
        _sub?.cancel();
        _sub = stream.listen(
          (s) {
            if (s != state) {
              state = s;
              notifyListeners();
            }
          },
          onError: (err) {
            notifyListeners();
          },
        );
      },
    );
  }

  void checkHasVault() async {
    _homeController.setLoading(true);
    var response = await userRepository.getUser();
    response.fold(
      (error) {
        setMessage(
          AlertData(
            message: "Não foi possível buscar os dados do usuário",
            errorType: ErrorType.error,
          ),
        );
      },
      (success) {
        hasVault = success.hasVault;
        notifyListeners();
      },
    );
    _homeController.setLoading(false);
  }
}
