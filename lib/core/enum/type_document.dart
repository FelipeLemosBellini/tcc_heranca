enum  TypeDocument {
  cpf,
  proofResidence,
  deathCertificate,
  procuracaoAdvogado;

  static TypeDocument toEnum(String value) {
    switch (value) {
      case "proofResidence":
        return TypeDocument.proofResidence;
      case "cpf":
        return TypeDocument.cpf;
      case "deathCertificate":
        return TypeDocument.deathCertificate;
      case "procuracaoAdvogado":
        return TypeDocument.procuracaoAdvogado;
      default:
        return TypeDocument.cpf;
    }
  }

  String get Name{
    switch(this){
      case TypeDocument.cpf:
        return "CPF";
      case TypeDocument.proofResidence:
        return "ComprovanteDeResidência";
      case TypeDocument.deathCertificate:
        return "CertidãoDeÓbito";
      case TypeDocument.procuracaoAdvogado:
        return "ProcuraçãoDoAdvogado";
      default:
        return "";
    }
  }

  static String labelPtOf(String value) => toEnum(value).Name;
}
