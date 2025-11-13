import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/enum/heir_status.dart';

class RequestInheritanceModel {
  String? id;
  String? testatorId;
  String? cpf; // cpf do cliente
  String? name; // nome do cliente
  String? requestById; // userId do solicitante
  String? requesterName;
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
    this.requesterName,
    this.heirStatus,
    this.rg,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestInheritanceModel.fromMap(Map<String, dynamic> json) {
    final testatorData = json['testatorUser'] as Map<String, dynamic>?;
    final requesterData = json['requesterUser'] as Map<String, dynamic>?;

    return RequestInheritanceModel(
      id: json['id']?.toString(),
      testatorId: json['testatorId'] ?? json['userId'],
      cpf: testatorData?['cpf'] ?? json['cpf'],
      name: testatorData?['name'] ?? json['name'],
      requestById: json['requestBy'],
      requesterName: requesterData?['name'] ?? json['requesterName'],
      heirStatus: DbMappings.heirStatusFromId(
        _tryParseInt(json['status']) ?? _tryParseInt(json['heirStatus']),
      ),
      rg: testatorData?['rg'] ?? json['rg'],
      createdAt:
          _parseDate(json['createdAt']) ?? _parseDate(json['created_at']),
      updatedAt:
          _parseDate(json['updatedAt']) ?? _parseDate(json['updated_at']),
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
