enum EnumDocumentsFrom {
  kyc,
  balanceRequest,
  inheritanceRequest;

  static EnumDocumentsFrom? toEnum(String value) {
    switch (value) {
      case "KYC":
        return EnumDocumentsFrom.kyc;
      case "BALANCE_REQUEST":
        return EnumDocumentsFrom.balanceRequest;
      case "INHERITANCE_REQUEST":
        return EnumDocumentsFrom.inheritanceRequest;
    }
    return null;
  }
}

extension EnumDocumentsFromExtension on EnumDocumentsFrom {
  String enumToString() {
    switch (this) {
      case EnumDocumentsFrom.kyc:
        return "Cadastro";
      case EnumDocumentsFrom.inheritanceRequest:
        return "Solicitação de distribuição";
      case EnumDocumentsFrom.balanceRequest:
        return "Solicitação de saldo";
    }
  }
}
