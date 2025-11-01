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
        return "Comprovante de Residencia";
      case TypeDocument.deathCertificate:
        return "Certidao de Obito";
      case TypeDocument.procuracaoAdvogado:
        return "Procuracao do Advogado";
      case TypeDocument.testamentDocument:
        return "Testamento";
      case TypeDocument.transferAssetsOrder:
        return "Ordem de Transferencia";
      case TypeDocument.inventoryProcess:
        return "Processo de Inventario";
      default:
        return "";
    }
  }

  static String labelPtOf(String value) => toEnum(value).Name;
}
