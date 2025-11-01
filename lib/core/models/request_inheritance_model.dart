import 'package:tcc/core/enum/heir_status.dart';

class RequestInheritanceModel {
  //preciso disso vamos criar uma colecao de heranca, que vai armazenar o nome do cliente, cpf, userId do cliente, request by id do solicitante, heirStatus, id da heranca
  String? id;
  String? userId; // userId do cliente
  String? cpf; // cpf do cliente
  String? name; // nome do cliente
  String? requestById; // userId do solicitante
  HeirStatus? heirStatus; // status da heranca
  String? rg;
  DateTime? createdAt;
  DateTime? updatedAt;

  RequestInheritanceModel({
    this.id,
    this.userId,
    this.cpf,
    this.name,
    this.requestById,
    this.heirStatus,
    this.rg,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestInheritanceModel.fromMap(Map<String, dynamic> json) {
    return RequestInheritanceModel(
      id: json['id'],
      userId: json['userId'],
      cpf: json['cpf'],
      name: json['name'],
      requestById: json['requestById'],
      heirStatus: HeirStatus.toEnum(json['heirStatus']) ??
          HeirStatus.consultaSaldoSolicitado,
      rg: json['rg'],
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'cpf': cpf,
      'name': name,
      'requestById': requestById,
      'heirStatus': (heirStatus ?? HeirStatus.consultaSaldoSolicitado).value,
      'rg': rg,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  try {
    return DateTime.parse(value.toString());
  } catch (_) {
    return null;
  }
}
