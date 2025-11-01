enum TypeDocument {
  cpf,
  proofResidence,
  deathCertificate,
  procuracaoAdvogado,
  testamentDocument,
  transferAssetsOrder,
  inventoryProcess;

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
      case "testamentDocument":
        return TypeDocument.testamentDocument;
      case "transferAssetsOrder":
        return TypeDocument.transferAssetsOrder;
      case "inventoryProcess":
        return TypeDocument.inventoryProcess;
      default:
        return TypeDocument.cpf;
    }
  }

  String get Name{
    switch(this){
      case TypeDocument.cpf:
        return "CPF";
      case TypeDocument.proofResidence:
        return "ComprovanteDeResidencia";
      case TypeDocument.deathCertificate:
        return "CertidaoDeObito";
      case TypeDocument.procuracaoAdvogado:
        return "ProcuracaoDoAdvogado";
      case TypeDocument.testamentDocument:
        return "Testamento";
      case TypeDocument.transferAssetsOrder:
        return "OrdemDeTransferencia";
      case TypeDocument.inventoryProcess:
        return "ProcessoDeInventario";
      default:
        return "";
    }
  }

  static String labelPtOf(String value) => toEnum(value).Name;
}
