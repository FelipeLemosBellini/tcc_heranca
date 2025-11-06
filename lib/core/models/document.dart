import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';

class Document {
  String? pathStorage;
  String? reviewMessage;
  final ReviewStatusDocument reviewStatus;
  final TypeDocument typeDocument;
  final DateTime uploadedAt;
  String? id;
  String? idDocument;
  String? ownerId;
  String? testatorId;
  EnumDocumentsFrom? from;

  Document({
    this.pathStorage,
    this.reviewMessage,
    required this.reviewStatus,
    required this.typeDocument,
    required this.uploadedAt,
    this.id,
    this.idDocument,
    this.ownerId,
    this.testatorId,
    this.from,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': ownerId ?? idDocument,
      'arquivo': pathStorage,
      'reviewMessage': reviewMessage,
      'numStatus': DbMappings.documentStatusToId(reviewStatus),
      'type': DbMappings.documentTypeToId(typeDocument),
      'createdAt': uploadedAt.toIso8601String(),
      'numFlux': DbMappings.fluxToId(from),
      'testatorId': testatorId,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    final createdAt =
        _parseDate(map['createdAt']) ?? _parseDate(map['uploadedAt']) ?? DateTime.now();
    final docId = _tryParseString(map['id']) ?? _tryParseString(map['documentId']);
    final ownerId =
        _tryParseString(map['idUser']) ??
        _tryParseString(map['ownerId']) ??
        _tryParseString(map['uid']);
    return Document(
      id: docId,
      idDocument: docId,
      ownerId: ownerId ?? _tryParseString(map['userId']),
      pathStorage: map['arquivo'] as String? ?? map['pathStorage'] as String?,
      reviewStatus: DbMappings.documentStatusFromId(_tryParseInt(map['numStatus'])),
      typeDocument: DbMappings.documentTypeFromId(_tryParseInt(map['type'])),
      reviewMessage: map['reviewMessage'] as String?,
      uploadedAt: createdAt,
      from: DbMappings.fluxFromId(_tryParseInt(map['numFlux'])),
      testatorId: _tryParseString(map['testatorId']) ?? _tryParseString(map['testator_id']),
    );
  }
}

String? _tryParseString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  return value.toString();
}

int? _tryParseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }
  return null;
}
