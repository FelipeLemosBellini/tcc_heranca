import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/enum/heir_status.dart';

class RequestInheritanceModel {
  String? id;
  String? testatorId;
  String? cpf; // cpf do cliente
  String? name; // nome do cliente
  String? requestById; // userId do solicitante
  HeirStatus? heirStatus; // status da herança
  String? rg;
  DateTime? createdAt;
  DateTime? updatedAt;

  RequestInheritanceModel({
    this.id,
    this.testatorId,
    this.cpf,
    this.name,
    this.requestById,
    this.heirStatus,
    this.rg,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestInheritanceModel.fromMap(Map<String, dynamic> json) {
    final userData = json['testatorUser'] as Map<String, dynamic>?;

    return RequestInheritanceModel(
      id: json['id'].toString(),
      testatorId: json['testatorId'] ?? json['userId'],
      cpf: userData?['cpf'],
      name: userData?['name'],
      requestById: json['requestBy'],
      heirStatus: DbMappings.heirStatusFromId(
        _tryParseInt(json['status']) ?? _tryParseInt(json['heirStatus']),
      ),
      rg: userData?['rg'],
      createdAt:
          _parseDate(json['createdAt']) ?? _parseDate(json['createdAt']),
      updatedAt:
          _parseDate(json['updatedAt']) ?? _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'testatorId': testatorId,
      'requestBy': requestById,
      'status': DbMappings.heirStatusToId(
        heirStatus ?? HeirStatus.consultaSaldoSolicitado,
      ),
      'rg': rg,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
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
