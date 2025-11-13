enum FunctionsBlockchainEnum {
  withdrawEth,
  depositEth,
  createVault,
  vaultBalance,
  myVault,
  distributeVault,
  iHaveVault;

  String get functionName {
    switch (this) {
      case FunctionsBlockchainEnum.withdrawEth:
        return "withdrawETH";
      case FunctionsBlockchainEnum.depositEth:
        return "depositETH";
      case FunctionsBlockchainEnum.createVault:
        return "createVault";
      case FunctionsBlockchainEnum.vaultBalance:
        return "vaultBalance";
      case FunctionsBlockchainEnum.myVault:
        return "myVault";
      case FunctionsBlockchainEnum.distributeVault:
        return "distributeVault";
      case FunctionsBlockchainEnum.iHaveVault:
        return "iHaveVault";
    }
  }
}
