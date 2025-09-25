enum EnumDocumentsFrom {
  kyc,
  vaultRequest,
  inheritanceRequest;

  static EnumDocumentsFrom? toEnum(String value) {
    switch (value) {
      case "kyc":
        return EnumDocumentsFrom.kyc;
      case "vaultRequest":
        return EnumDocumentsFrom.vaultRequest;
      case "inheritanceRequest":
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
      case EnumDocumentsFrom.vaultRequest:
        return "VAULT_REQUEST";
      case EnumDocumentsFrom.inheritanceRequest:
        return "INHERITANCE_REQUEST";
    }
  }
}
