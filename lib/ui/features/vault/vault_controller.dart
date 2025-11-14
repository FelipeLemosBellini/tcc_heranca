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
}
