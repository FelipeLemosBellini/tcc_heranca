enum EnumDocumentsFrom {
  kyc,
  inheritanceRequest;

  static EnumDocumentsFrom? toEnum(String value) {
    switch (value) {
      case "kyc":
        return EnumDocumentsFrom.kyc;
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
      case EnumDocumentsFrom.inheritanceRequest:
        return "INHERITANCE_REQUEST";
    }
  }
}
