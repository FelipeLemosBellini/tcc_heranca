enum TypeDocument {
  cpf,
  proofResidence;

  static TypeDocument toEnum(String value) {
    switch (value) {
      case "proofResidence":
        return TypeDocument.proofResidence;
      case "cpf":
      default:
        return TypeDocument.cpf;
    }
  }
}
