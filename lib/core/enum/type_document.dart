enum  TypeDocument {
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

  String get Name{
    switch(this){
      case TypeDocument.cpf:
        return "CPF";
      case TypeDocument.proofResidence:
        return "Comprovante de Residência";
      default:
        return "";
    }
  }

  static String labelPtOf(String value) => toEnum(value).Name;
}
