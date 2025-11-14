import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:tcc/core/constants/blockchain_constants.dart';
import 'package:tcc/core/enum/connect_state_blockchain.dart';
import 'package:tcc/core/enum/functions_blockchain_enum.dart';
import 'package:tcc/core/environment/env.dart';
import 'package:tcc/core/exceptions/exception_message.dart';

class BlockchainRepository {
  StreamController<ConnectStateBlockchain>? _controller;
  ConnectStateBlockchain? _last;
  bool _listening = false;

  late IReownAppKitModal _appKitModal;

  late ContractAbi _contractAbi;

  late EthereumAddress _ethereumAddress;

  late DeployedContract _deployedContract;

  Future<Either<ExceptionMessage, void>> init({
    required BuildContext context,
  }) async {
    try {
      _contractAbi = ContractAbi.fromJson(
        BlockchainConstants.abi,
        BlockchainConstants.contractName,
      );
      _ethereumAddress = EthereumAddress.fromHex(
        BlockchainConstants.addressSmartContract,
      );
      _deployedContract = DeployedContract(_contractAbi, _ethereumAddress);

      final requiredNamespaces = <String, RequiredNamespace>{
        'eip155': RequiredNamespace.fromJson({
          'chains': ['eip155:11155111'], // Sepolia
          'methods': NetworkUtils.defaultNetworkMethods['eip155']!.toList(),
          'events': NetworkUtils.defaultNetworkEvents['eip155']!.toList(),
        }),
      };

      _appKitModal = ReownAppKitModal(
        context: context,
        projectId: Env.projectReownId,
        optionalNamespaces: requiredNamespaces,
        metadata: const PairingMetadata(
          name: BlockchainConstants.projectName,
          description: BlockchainConstants.descriptionOfProject,
          url: BlockchainConstants.urlProject,

          redirect: Redirect(native: 'com.tcc_heranca://', linkMode: false),
        ),
      );
      await _appKitModal.init();
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, String>> getAddress() async {
    try {
      if (_appKitModal.session == null) {
        return Left(ExceptionMessage("Conecte sua carteira"));
      }
      List<String>? addresses = _appKitModal.session?.getAccounts();

      if (addresses == null || addresses.isEmpty) {
        return Left(ExceptionMessage("Endereço público não encontrado"));
      }
      return Right(_getConnectedAddress().hex);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, void>> connectWallet() async {
    try {
      await _appKitModal.selectChain(
        const ReownAppKitModalNetworkInfo(
          isTestNetwork: true,
          chainId: BlockchainConstants.chainId,
          name: BlockchainConstants.nameChain,
          currency: BlockchainConstants.currency,
          rpcUrl: BlockchainConstants.rpcUrl,
          explorerUrl: BlockchainConstants.explorerUrl,
        ),
      );
      await _appKitModal.openModalView();
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, void>> createVault() async {
    try {
      ContractFunction contractFunction = _getContractFunction(
        FunctionsBlockchainEnum.createVault,
      );
      Transaction transaction = Transaction.callContract(
        contract: _deployedContract,
        function: contractFunction,
        from: _getConnectedAddress(),
        value: EtherAmount.fromBigInt(
          EtherUnit.wei,
          BigInt.from(10000000000000),
        ),
        parameters: [],
      );
      await _appKitModal.selectChain(
        const ReownAppKitModalNetworkInfo(
          isTestNetwork: true,
          chainId: BlockchainConstants.chainId,
          name: BlockchainConstants.nameChain,
          currency: BlockchainConstants.currency,
          rpcUrl: BlockchainConstants.rpcUrl,
          explorerUrl: BlockchainConstants.explorerUrl,
        ),
      );
      await _appKitModal.requestWriteContract(
        topic: _appKitModal.session?.topic,
        chainId: BlockchainConstants.chainId,
        deployedContract: _deployedContract,
        functionName: FunctionsBlockchainEnum.createVault.functionName,
        transaction: transaction,
      );
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, void>> depositEth({
    required BigInt amountInWei,
  }) async {
    try {
      ContractFunction contractFunction = _getContractFunction(
        FunctionsBlockchainEnum.depositEth,
      );
      Transaction transaction = Transaction.callContract(
        contract: _deployedContract,
        function: contractFunction,
        from: _getConnectedAddress(),
        value: EtherAmount.fromBigInt(EtherUnit.wei, amountInWei),
        parameters: [],
      );
      await _appKitModal.requestWriteContract(
        topic: _appKitModal.session?.topic,
        chainId: BlockchainConstants.chainId,
        deployedContract: _deployedContract,
        functionName: FunctionsBlockchainEnum.depositEth.functionName,
        transaction: transaction,
      );
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, void>> withdrawEth({
    required BigInt amountInWei,
  }) async {
    try {
      ContractFunction contractFunction = _getContractFunction(
        FunctionsBlockchainEnum.withdrawEth,
      );
      List<dynamic> parameters = [amountInWei];
      Transaction transaction = Transaction.callContract(
        contract: _deployedContract,
        function: contractFunction,
        from: _getConnectedAddress(),
        parameters: parameters,
      );
      await _appKitModal.requestWriteContract(
        topic: _appKitModal.session?.topic,
        chainId: BlockchainConstants.chainId,
        deployedContract: _deployedContract,
        functionName: FunctionsBlockchainEnum.withdrawEth.functionName,
        transaction: transaction,
        parameters: parameters,
      );
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, void>> distributeVault({
    required String testatorAddress,
    required List<BigInt> amounts,
    required List<String> addresses,
  }) async {
    try {
      ContractFunction contractFunction = _getContractFunction(
        FunctionsBlockchainEnum.distributeVault,
      );
      List<dynamic> parameters = [testatorAddress, addresses, amounts];
      Transaction transaction = Transaction.callContract(
        contract: _deployedContract,
        function: contractFunction,
        from: _getConnectedAddress(),
        parameters: parameters,
      );
      await _appKitModal.requestWriteContract(
        topic: _appKitModal.session?.topic,
        chainId: BlockchainConstants.chainId,
        deployedContract: _deployedContract,
        functionName: FunctionsBlockchainEnum.distributeVault.functionName,
        transaction: transaction,
        parameters: parameters,
      );
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, BigInt>> myVault() async {
    try {
      var response = await _appKitModal.requestReadContract(
        topic: _appKitModal.session?.topic,
        chainId: BlockchainConstants.chainId,
        deployedContract: _deployedContract,
        functionName: FunctionsBlockchainEnum.myVault.functionName,
      );

      return Right(response[0][0] as BigInt);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, BigInt>> vaultBalanceByAddress({
    required String address,
  }) async {
    try {
      List<dynamic> parameters = [EthereumAddress.fromHex(address)];
      var response = await _appKitModal.requestReadContract(
        topic: _appKitModal.session?.topic,
        chainId: BlockchainConstants.chainId,
        deployedContract: _deployedContract,
        functionName: FunctionsBlockchainEnum.vaultBalance.functionName,
        parameters: parameters,
      );

      return Right(response.first as BigInt);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, Stream<ConnectStateBlockchain>>>
  watchState() async {
    try {
      _controller ??= StreamController<ConnectStateBlockchain>.broadcast(
        sync: true,
      );

      if (!_listening) {
        _appKitModal.addListener(_emit);
        _listening = true;
        _emit();
      }

      return Right(_controller!.stream);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  Future<Either<ExceptionMessage, void>> logout() async {
    try {
      if (_appKitModal.session != null) {
        await _appKitModal.disconnect();
      }
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  void dispose() async {
    if (_listening) {
      _appKitModal.removeListener(_emit);
      _listening = false;
    }
    _controller?.close();
  }

  void _emit() {
    final controller = _controller;
    if (controller == null || controller.isClosed) return;

    final next = _mapToBlockchainState(_appKitModal);

    controller.add(next);
  }

  ConnectStateBlockchain _mapToBlockchainState(IReownAppKitModal appKit) {
    if (appKit.status == ReownAppKitModalStatus.error) {
      return ConnectStateBlockchain.error;
    } else if (appKit.isConnected) {
      return ConnectStateBlockchain.connected;
    } else if (!appKit.hasNamespaces) {
      return ConnectStateBlockchain.disabled;
    } else if (appKit.isOpen && !appKit.isConnected) {
      return ConnectStateBlockchain.connecting;
    } else {
      return ConnectStateBlockchain.idle;
    }
  }

  ContractFunction _getContractFunction(FunctionsBlockchainEnum funcType) {
    if (FunctionsBlockchainEnum.createVault == funcType) {
      return _contractAbi.functions.firstWhere(
        (ContractFunction function) => function.name == 'createVault',
      );
    } else if (FunctionsBlockchainEnum.withdrawEth == funcType) {
      return _contractAbi.functions.firstWhere(
        (ContractFunction function) => function.name == 'withdrawETH',
      );
    } else if (FunctionsBlockchainEnum.depositEth == funcType) {
      return _contractAbi.functions.firstWhere(
        (ContractFunction function) => function.name == 'depositETH',
      );
    } else if (FunctionsBlockchainEnum.vaultBalance == funcType) {
      return _contractAbi.functions.firstWhere(
        (ContractFunction function) => function.name == 'vaultBalance',
      );
    } else if (FunctionsBlockchainEnum.myVault == funcType) {
      return _contractAbi.functions.firstWhere(
        (ContractFunction function) => function.name == 'myVault',
      );
    } else if (FunctionsBlockchainEnum.distributeVault == funcType) {
      return _contractAbi.functions.firstWhere(
        (ContractFunction function) => function.name == 'distributeVault',
      );
    } else {
      return _contractAbi.functions.firstWhere(
        (ContractFunction function) => function.name == 'iHaveVault',
      );
    }
  }

  EthereumAddress _getConnectedAddress() {
    final session = _appKitModal.session;
    if (session == null) {
      throw Exception(
        'Carteira não conectada. Conecte-se antes de transacionar.',
      );
    }
    final accounts = session.getAccounts();
    if (accounts == null || accounts.isEmpty) {
      throw Exception('Nenhuma conta encontrada na sessão.');
    }
    final caip10 = accounts.first;
    final hex = caip10.contains(':') ? caip10.split(':').last : caip10;
    return EthereumAddress.fromHex(hex);
  }
}
