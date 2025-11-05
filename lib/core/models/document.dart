import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';

class Document {
  String? content;
  String? pathStorage;
  String? reviewMessage;
  final ReviewStatusDocument reviewStatus;
  final TypeDocument typeDocument;
  final DateTime uploadedAt;
  String? id;
  String? idDocument;
  String? ownerId;
  EnumDocumentsFrom? from;

  Document({
    this.content,
    this.pathStorage,
    this.reviewMessage,
    required this.reviewStatus,
    required this.typeDocument,
    required this.uploadedAt,
    this.id,
    this.idDocument,
    this.ownerId,
    this.from,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': ownerId ?? idDocument,
      'content': content,
      'arquivo': pathStorage,
      'reviewMessage': reviewMessage,
      'numStatus': DbMappings.documentStatusToId(reviewStatus),
      'type': DbMappings.documentTypeToId(typeDocument),
      'created_at': uploadedAt.toIso8601String(),
      'numFlux': DbMappings.fluxToId(from),
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    final createdAt =
        _parseDate(map['created_at']) ?? _parseDate(map['uploadedAt']) ?? DateTime.now();
    final docId = map['id'] as String? ?? map['documentId'] as String?;
    final ownerId =
        map['idUser'] as String? ?? map['ownerId'] as String? ?? map['uid'] as String?;
    return Document(
      id: docId,
      idDocument: docId,
      ownerId: ownerId ?? map['userId'] as String?,
      content: map['content'] as String?,
      pathStorage: map['arquivo'] as String? ?? map['pathStorage'] as String?,
      reviewStatus: DbMappings.documentStatusFromId(_tryParseInt(map['numStatus'])),
      typeDocument: DbMappings.documentTypeFromId(_tryParseInt(map['type'])),
      reviewMessage: map['reviewMessage'] as String?,
      uploadedAt: createdAt,
      from: DbMappings.fluxFromId(_tryParseInt(map['numFlux'])),
    );
  }
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
