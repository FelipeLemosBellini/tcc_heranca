import 'package:tcc/core/constants/db_mappings.dart';
import 'package:tcc/core/enum/kyc_status.dart';

class UserModel {
  String? id;
  String? rg;
  String? cpf;
  final String name;
  final String email;
  final String? address;
  final bool? isAdmin;
  KycStatus kycStatus;
  bool hasVault;
  DateTime? createdAt;

  UserModel({
    required this.name,
    required this.email,
    required this.kycStatus,
    this.isAdmin = false,
    this.cpf,
    this.rg,
    this.address,
    this.id,
    this.hasVault = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cpf': cpf,
      'rg': rg,
      'name': name,
      'email': email,
      'address': address,
      'numKycStatus': DbMappings.kycStatusToId(kycStatus),
      'isAdmin': isAdmin,
      'id': id,
      'hasVault': hasVault,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      cpf: map['cpf'] ?? '',
      rg: map['rg'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      kycStatus: DbMappings.kycStatusFromId(_tryParseInt(map['numKycStatus'])) ??
          KycStatus.convertStringToEnum(map['kycStatus'] ?? ''),
      address: map['address'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      id: map['id'] ?? '',
      hasVault: map['hasVault'] ?? false,
      createdAt: _parseDate(map['createdAt']),
    );
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
