import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:tcc/core/repositories/blockchain_repository/blockchain_repository_interface.dart';
import 'package:web3dart/web3dart.dart';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:tcc/core/constants/blockchain_constants.dart';
import 'package:tcc/core/enum/connect_state_blockchain.dart';
import 'package:tcc/core/enum/functions_blockchain_enum.dart';
import 'package:tcc/core/environment/env.dart';
import 'package:tcc/core/exceptions/exception_message.dart';

class BlockchainRepository extends BlockchainRepositoryInterface {
  StreamController<ConnectStateBlockchain>? _controllerState;
  StreamController<BigInt>? _walletBalance;
  bool _listeningConnectState = false;
  bool _listeningWalletBalance = false;

  late IReownAppKitModal _appKitModal;

  late ContractAbi _contractAbi;

  late EthereumAddress _ethereumAddress;

  late DeployedContract _deployedContract;

  @override
  Future<Either<ExceptionMessage, bool>> reownWasInitialized() async {
    try {
      return Right(_appKitModal.status == ReownAppKitModalStatus.initialized);
    } catch (e) {
      return Right(false);
    }
  }

  @override
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

      _appKitModal = ReownAppKitModal(
        context: context,
        projectId: Env.projectReownId,
        optionalNamespaces: requiredNamespaces(),
        metadata: const PairingMetadata(
          name: BlockchainConstants.projectName,
          description: BlockchainConstants.descriptionOfProject,
          url: BlockchainConstants.urlProject,

          redirect: Redirect(native: 'com.tcc_heranca://', linkMode: false),
        ),
      );
      await _appKitModal.init();
      _getConnectedAddress();
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  @override
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

  @override
  Future<Either<ExceptionMessage, void>> connectWallet() async {
    try {
      await _selectNetwork();
      await _appKitModal.openModalView();
      return Right(null);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  @override
  Future<Either<ExceptionMessage, String>> createVault() async {
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
      await _selectNetwork();
      var response = await _appKitModal.requestWriteContract(
        topic: _appKitModal.session?.topic,
        chainId: BlockchainConstants.chainId,
        deployedContract: _deployedContract,
        functionName: FunctionsBlockchainEnum.createVault.functionName,
        transaction: transaction,
      );
      print(response);
      return Right(response);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  @override
  Future<Either<ExceptionMessage, void>> depositEth({
    required BigInt amountInWei,
  }) async {
    try {
      List<String>? list = _appKitModal.getAvailableChains();
      list?.forEach((item) {
        print(item);
      });
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
      await _selectNetwork();
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

  @override
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

  @override
  Future<Either<ExceptionMessage, void>> distributeVault({
    required String testatorAddress,
    required List<BigInt> amounts,
    required List<String> addresses,
  }) async {
    try {
      ContractFunction contractFunction = _getContractFunction(
        FunctionsBlockchainEnum.distributeVault,
      );
      List<EthereumAddress> address = [];
      addresses.forEach((action) {
        address.add(EthereumAddress.fromHex(action));
      });
      List<dynamic> parameters = [
        EthereumAddress.fromHex(testatorAddress),
        address,
        amounts,
      ];
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
      print(e);
      return Left(ExceptionMessage(e.toString()));
    }
  }

  @override
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

  @override
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

  @override
  Future<Either<ExceptionMessage, Stream<ConnectStateBlockchain>>>
  watchState() async {
    try {
      _controllerState ??= StreamController<ConnectStateBlockchain>.broadcast(
        sync: true,
      );

      if (!_listeningConnectState) {
        _appKitModal.addListener(_emit);
        _listeningConnectState = true;
        _emit();
      }

      return Right(_controllerState!.stream);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  @override
  Future<Either<ExceptionMessage, Stream<BigInt>>> getWalletBalance() async {
    try {
      _walletBalance ??= StreamController<BigInt>.broadcast(sync: true);
      if (!_listeningWalletBalance) {
        await _selectNetwork();
        _appKitModal.balanceNotifier.addListener(_emitWalletBalance);
        _listeningWalletBalance = true;
      }
      _emitWalletBalance();
      return Right(_walletBalance!.stream);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }

  @override
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

  @override
  void dispose() async {
    if (_listeningConnectState || _listeningWalletBalance) {
      _appKitModal.removeListener(_emit);
      _appKitModal.balanceNotifier.removeListener(_emitWalletBalance);
      _listeningConnectState = false;
    }
    _controllerState?.close();
    _walletBalance?.close();
  }

  void _emit() {
    final controller = _controllerState;
    if (controller == null || controller.isClosed) return;

    final next = _mapToBlockchainState(_appKitModal);

    controller.add(next);
  }

  void _emitWalletBalance() async {
    final controller = _walletBalance;
    if (controller == null || controller.isClosed) return;

    var response = await getNativeBalanceWei();
    response.fold((onLeft) {}, (success) {
      controller.add(success);
    });
  }

  // 1) Pega o address conectado via Reown (CAIP-10 -> 0x...)
  EthereumAddress _connectedAddressOrThrow() {
    final accounts = _appKitModal.session?.getAccounts();
    if (accounts == null || accounts.isEmpty) {
      throw Exception('Carteira não conectada');
    }
    final caip10 = accounts.first; // ex: eip155:11155111:0xABC...
    final hex = caip10.split(':').last; // -> 0xABC...
    return EthereumAddress.fromHex(hex);
  }

  // 2) Lê o saldo em wei direto do RPC (sem arredondar)
  @override
  Future<Either<ExceptionMessage, BigInt>> getNativeBalanceWei() async {
    final addr = _connectedAddressOrThrow();
    final client = Web3Client(
      'https://1rpc.io/sepolia',
      http.Client(),
    ); // ou seu RPC
    try {
      final EtherAmount bal = await client.getBalance(addr);
      return Right(bal.getInWei); // BigInt preciso
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    } finally {
      client.dispose();
    }
  }

  @override
  Future<Either<ExceptionMessage, bool>> checkTransactionWasExecuted(
    String hash,
  ) async {
    Duration pollInterval = const Duration(seconds: 3);
    int maxTries = 60;
    final client = Web3Client('https://1rpc.io/sepolia', http.Client());

    try {
      for (int i = 0; i < maxTries; i++) {
        final TransactionReceipt? receipt = await client.getTransactionReceipt(
          hash,
        );

        if (receipt != null && receipt.status != null) {
          final bool status = receipt.status!;
          return Right(status);
        }

        await Future.delayed(pollInterval);
      }

      return Left(
        ExceptionMessage(
          'Timeout ao aguardar a confirmação da transação ($hash).',
        ),
      );
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    } finally {
      client.dispose();
    }
  }

  // 3) Formata BigInt com n casas decimais (sem usar double)
  @override
  String formatUnits(
    BigInt amount, {
    int decimals = 18,
    int precision = 18, // quantas casas mostrar (<= decimals)
    bool trimTrailingZeros = true,
  }) {
    final s = amount.toString();
    if (decimals == 0) return s;

    // separa parte inteira e fracionária
    String intPart, fracPart;
    if (s.length <= decimals) {
      intPart = '0';
      fracPart = s.padLeft(decimals, '0');
    } else {
      final cut = s.length - decimals;
      intPart = s.substring(0, cut);
      fracPart = s.substring(cut);
    }

    // aplica precisão
    if (precision < decimals) {
      fracPart = fracPart.substring(0, precision);
    }

    if (trimTrailingZeros) {
      fracPart = fracPart.replaceFirst(RegExp(r'0+$'), '');
    }

    return fracPart.isEmpty ? intPart : '$intPart.$fracPart';
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

  Future<void> _selectNetwork() async {
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
  }

  @override
  Map<String, RequiredNamespace> requiredNamespaces() {
    return <String, RequiredNamespace>{
      'eip155': RequiredNamespace.fromJson({
        'chains': ['eip155:11155111'], // Sepolia
        'methods': NetworkUtils.defaultNetworkMethods['eip155']!.toList(),
        'events': NetworkUtils.defaultNetworkEvents['eip155']!.toList(),
      }),
    };
  }

  @override
  Future<Either<ExceptionMessage, bool>> checkIHaveVault() async {
    try {
      List<dynamic> response = await _appKitModal.requestReadContract(
        topic: _appKitModal.session?.topic,
        chainId: BlockchainConstants.chainId,
        deployedContract: _deployedContract,
        functionName: FunctionsBlockchainEnum.iHaveVault.functionName,
      );

      return Right(response.first);
    } catch (e) {
      return Left(ExceptionMessage(e.toString()));
    }
  }
}
