enum EnumDocumentsFrom {
  kyc,
  vaultRequest,
  inheritanceRequest,
}


String enumToString(EnumDocumentsFrom document) {
  switch (document) {
    case EnumDocumentsFrom.kyc:
      return "KYC";
    case EnumDocumentsFrom.vaultRequest:
      return "VAULT_REQUEST";
    case EnumDocumentsFrom.inheritanceRequest:
      return "INHERITANCE_REQUEST";
  }
}