enum KycStatus { draft, submitted, approved, rejected }

class KycModel {
  final String cpf;
  final String rg;
  final KycStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  KycModel({
    required this.cpf,
    required this.rg,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,
      'rg': rg,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory KycModel.fromMap(Map<String, dynamic> map) {
    return KycModel(
      cpf: map['cpf'] ?? '',
      rg: map['rg'] ?? '',
      status: _statusFromString(map['status'] as String?),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  static KycStatus _statusFromString(String? value) {
    switch (value) {
      case 'submitted':
        return KycStatus.submitted;
      case 'approved':
        return KycStatus.approved;
      case 'rejected':
        return KycStatus.rejected;
      case 'draft':
      default:
        return KycStatus.draft;
    }
  }
}

