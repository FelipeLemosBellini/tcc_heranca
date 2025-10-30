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
        return "KYC";
      case EnumDocumentsFrom.inheritanceRequest:
        return "INHERITANCE_REQUEST";
      case EnumDocumentsFrom.balanceRequest:
        return "BALANCE_REQUEST";
    }
  }
}
