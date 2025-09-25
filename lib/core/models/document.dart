import 'package:tcc/core/enum/enum_documents_from.dart';
import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';

class Document {
  final String? content;
  String? pathStorage;
  String? reviewMessage;
  final ReviewStatusDocument reviewStatus;
  final TypeDocument typeDocument;
  final DateTime uploadedAt;
  String? id;
  String? idDocument;
  final EnumDocumentsFrom from;

  Document({
    this.content,
    this.pathStorage,
    this.reviewMessage,
    required this.reviewStatus,
    required this.typeDocument,
    required this.uploadedAt,
    this.id,
    this.idDocument,
    required this.from,
  });

  Map<String, dynamic> toMap() {
    return {
      "content": content,
      "pathStorage": pathStorage,
      "reviewMessage": reviewMessage,
      "reviewStatus": reviewStatus.name,
      "type": typeDocument.name,
      "uploadedAt": uploadedAt.toIso8601String(),
      "id": id,
      "from": from.name,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      pathStorage: map['pathStorage'] ?? '',
      reviewStatus: ReviewStatusDocument.toEnum(map['reviewStatus'] ?? ''),
      typeDocument: TypeDocument.toEnum(map['type'] ?? ''),
      reviewMessage: map['reviewMessage'] ?? '',
      uploadedAt: DateTime.tryParse(map['uploadedAt'] ?? '') ?? DateTime.now(),
      from: map['from'] ?? '',
    );
  }
}
