class VaultModel {
  final String id;
  final String userId;
  final String cpf;

  final DateTime createdAt;

  VaultModel({
    required this.id,
    required this.userId,
    required this.cpf,
    required this.createdAt,
  });

  factory VaultModel.fromJson(Map<String, dynamic> json) {
    return VaultModel(
      id: json['id'],
      userId: json['userId'],
      cpf: json['cpf'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cpf': cpf,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}