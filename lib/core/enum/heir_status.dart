// HeirStatus.dart
// Remova 'dart:ui' se não usar Color aqui.
enum HeirStatus {
  consultaSaldoSolicitado,
  consultaSaldoAprovado,
  consultaSaldoRecusado,
  transferenciaSaldoSolicitado,
  transferenciaSaldoRealizada,
  transferenciaSaldoRecusado;

  static HeirStatus? toEnum(String value) {
    switch (value) {
      case "CONSULTA_SALDO_SOLICITADO":
        return HeirStatus.consultaSaldoSolicitado;
      case "CONSULTA_SALDO_APROVADO":
        return HeirStatus.consultaSaldoAprovado;
      case "CONSULTA_SALDO_RECUSADO":
        return HeirStatus.consultaSaldoRecusado;
      case "TRANSFERENCIA_SALDO_SOLICITADO":
        return HeirStatus.transferenciaSaldoSolicitado;
      case "TRANSFERENCIA_SALDO_REALIZADA":
        return HeirStatus.transferenciaSaldoRealizada;
      case "TRANSFERENCIA_SALDO_RECUSADO":
        return HeirStatus.transferenciaSaldoRecusado;
      default:
        return null;
    }
  }
}

extension HeirStatusX on HeirStatus {
  /// Para persistência (SNAKE_UPPERCASE)
  String get value {
    switch (this) {
      case HeirStatus.consultaSaldoSolicitado:
        return "CONSULTA_SALDO_SOLICITADO";
      case HeirStatus.consultaSaldoAprovado:
        return "CONSULTA_SALDO_APROVADO";
      case HeirStatus.consultaSaldoRecusado:
        return "CONSULTA_SALDO_RECUSADO";
      case HeirStatus.transferenciaSaldoSolicitado:
        return "TRANSFERENCIA_SALDO_SOLICITADO";
      case HeirStatus.transferenciaSaldoRealizada:
        return "TRANSFERENCIA_SALDO_REALIZADA";
      case HeirStatus.transferenciaSaldoRecusado:
        return "TRANSFERENCIA_SALDO_RECUSADO";
    }
  }

  /// Label amigável para UI
  String get label {
    switch (this) {
      case HeirStatus.consultaSaldoSolicitado:
        return "Consulta de Saldo — Solicitada";
      case HeirStatus.consultaSaldoAprovado:
        return "Consulta de Saldo — Aprovada";
      case HeirStatus.consultaSaldoRecusado:
        return "Consulta de Saldo — Recusada";
      case HeirStatus.transferenciaSaldoSolicitado:
        return "Transferência de Saldo — Solicitada";
      case HeirStatus.transferenciaSaldoRealizada:
        return "Transferência de Saldo — Realizada";
      case HeirStatus.transferenciaSaldoRecusado:
        return "Transferência de Saldo — Recusada";
    }
  }
}
