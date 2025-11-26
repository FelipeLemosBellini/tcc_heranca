import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:tcc/core/enum/connect_state_blockchain.dart';
import 'package:tcc/core/exceptions/exception_message.dart';

abstract class BlockchainRepositoryInterface {
  Future<Either<ExceptionMessage, bool>> reownWasInitialized();

  Future<Either<ExceptionMessage, void>> init({required BuildContext context});

  Future<Either<ExceptionMessage, String>> getAddress();

  Future<Either<ExceptionMessage, void>> connectWallet();

  Future<Either<ExceptionMessage, void>> createVault();

  Future<Either<ExceptionMessage, void>> depositEth({
    required BigInt amountInWei,
  });

  Future<Either<ExceptionMessage, void>> withdrawEth({
    required BigInt amountInWei,
  });

  Future<Either<ExceptionMessage, void>> distributeVault({
    required String testatorAddress,
    required List<BigInt> amounts,
    required List<String> addresses,
  });

  Future<Either<ExceptionMessage, BigInt>> myVault();

  Future<Either<ExceptionMessage, BigInt>> vaultBalanceByAddress({
    required String address,
  });

  Future<Either<ExceptionMessage, Stream<ConnectStateBlockchain>>> watchState();

  Future<Either<ExceptionMessage, Stream<BigInt>>> getWalletBalance();

  Future<Either<ExceptionMessage, void>> logout();

  void dispose();

  Future<Either<ExceptionMessage, BigInt>> getNativeBalanceWei();

  String formatUnits(
    BigInt amount, {
    int decimals = 18,
    int precision = 18,
    bool trimTrailingZeros = true,
  });

  Map<String, RequiredNamespace> requiredNamespaces();

  Future<Either<ExceptionMessage, bool>> checkTransactionWasExecuted(
    String hash,
  );

  Future<Either<ExceptionMessage, bool>> checkIHaveVault();
}
