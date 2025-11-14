import 'dart:async';

import 'package:flutter/cupertino.dart';
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

  String balance = "0";

  bool? hasVault;

  Future<void> init(BuildContext context) async {
    _homeController.setLoading(true);
    await blockchainRepository.init(context: context).whenComplete(() async {
      await startWatchState();
    });
    _homeController.setLoading(false);
  }

  Future<void> connectWallet() async {
    var response = await blockchainRepository.connectWallet();
    await response.fold((onLeft) {}, (onRight) async {
      if (state == ConnectStateBlockchain.connected) {
        await checkHasVault();
      }
    });
  }

  Future<void> startWatchState() async {
    _homeController.setLoading(true);
    final result = await blockchainRepository.watchState();
    await result.fold(
      (err) {
        notifyListeners();
      },
      (stream) async {
        stream.listen(
          (s) async {
            if (s != state) {
              state = s;
              if (state == ConnectStateBlockchain.connected) {
                await checkHasVault();
              }
              notifyListeners();
            }
          },
          onError: (err) {
            notifyListeners();
          },
        );
      },
    );
    _homeController.setLoading(false);
  }

  Future<void> checkHasVault() async {
    _homeController.setLoading(true);

    var responseMyVault = await blockchainRepository.myVault();
    responseMyVault.fold((onLeft) {}, (onRight) {
      balance = onRight.toString();
      notifyListeners();
    });
    var response = await userRepository.getUser();
    await response.fold(
      (error) {
        setMessage(
          AlertData(
            message: "Não foi possível buscar os dados do usuário",
            errorType: ErrorType.error,
          ),
        );
      },
      (success) async {
        hasVault = success.hasVault;
        if (success.address == null || success.address == "") {
          var responseAddress = await blockchainRepository.getAddress();
          await responseAddress.fold((onLeft) {}, (address) async {
            await userRepository.setAddressUser(address);
          });
        }
        notifyListeners();
      },
    );
    _homeController.setLoading(false);
  }

  Future<void> buyVault() async {
    setLoading(true);
    var response = await blockchainRepository.createVault();
    response.fold((onLeft) {}, (onRight) {});
    setLoading(false);
  }
}
