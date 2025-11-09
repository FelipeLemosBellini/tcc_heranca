import 'package:tcc/core/constants/db_mappings.dart';
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
    final userData = json['users'] as Map<String, dynamic>?;
    return RequestInheritanceModel(
      id: json['id'],
      userId: json['userId'] ?? json['testatorId'],
      cpf: json['cpf'] ?? userData?['cpf'],
      name: json['name'] ?? userData?['name'],
      requestById: json['requestById'] ?? json['requestBy'],
      heirStatus: DbMappings.heirStatusFromId(_tryParseInt(json['status']) ??
              _tryParseInt(json['heirStatus'])),
      rg: json['rg'] ?? userData?['rg'],
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'testatorId': userId,
      'requestBy': requestById,
      'status':
          DbMappings.heirStatusToId(heirStatus ?? HeirStatus.consultaSaldoSolicitado),
      'rg': rg,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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

int? _tryParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
