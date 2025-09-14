import 'package:tcc/core/enum/review_status_document.dart';
import 'package:tcc/core/enum/type_document.dart';

class UserDocument {
  final String content;
  String? pathStorage;
  final String? reviewMessage;
  final ReviewStatusDocument reviewStatus;
  final TypeDocument typeDocument;
  final DateTime uploadedAt;
  String? id;

  UserDocument({
    required this.content,
    this.pathStorage,
    this.reviewMessage,
    required this.reviewStatus,
    required this.typeDocument,
    required this.uploadedAt,
    this.id,
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
    };
  }

  factory UserDocument.fromMap(Map<String, dynamic> map) {
    return UserDocument(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      pathStorage: map['pathStorage'] ?? '',
      reviewStatus: ReviewStatusDocument.toEnum(map['reviewStatus'] ?? ''),
      typeDocument: TypeDocument.toEnum(map['type'] ?? ''),
      reviewMessage: map['reviewMessage'] ?? '',
      uploadedAt: DateTime.tryParse(map['uploadedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
