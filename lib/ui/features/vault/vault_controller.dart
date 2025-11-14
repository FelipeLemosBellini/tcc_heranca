import 'dart:async';

import 'package:tcc/core/helpers/base_controller.dart';
import 'package:tcc/core/repositories/blockchain_repository/blockchain_repository.dart';

class VaultController extends BaseController {
  final BlockchainRepository blockchainRepository;

  VaultController({required this.blockchainRepository});

  BigInt balance = BigInt.zero;

  Future<void> getWalletBalance() async {
    var response = await blockchainRepository.getWalletBalance();
    await response.fold(
      (err) {
        notifyListeners();
      },
      (stream) async {
        stream.listen(
          (BigInt walletBalance) async {
            print("balance: ${walletBalance.toString()}");
            if (walletBalance != balance) {
              balance = walletBalance;
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

  Future<void> getVaultBalance() async {
    setLoading(true);
    var response = await blockchainRepository.myVault();
    response.fold((onLeft) {}, (onRight) {
      balance = onRight;
    });
    setLoading(false);
  }

  Future<void> deposit(BigInt value) async {
    setLoading(true);
    var response = await blockchainRepository.depositEth(amountInWei: value);
    response.fold((onLeft) {}, (onRight) {});
    setLoading(false);
  }

  Future<bool> withdraw(BigInt value) async {
    bool withdrawSuccess = false;
    setLoading(true);
    var response = await blockchainRepository.withdrawEth(amountInWei: value);
    response.fold((onLeft) {}, (onRight) {
      withdrawSuccess = true;
    });

    setLoading(false);
    return withdrawSuccess;
  }
}
