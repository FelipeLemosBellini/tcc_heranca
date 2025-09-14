import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/models/kyc_model.dart';

class UserModel {
  final String name;
  final String email;
  final String? address;
  KycStatus kycStatus;

  UserModel({
    required this.name,
    required this.email,
    required this.kycStatus,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "email": email,
      "address": address,
      "kycStatus": kycStatus.name,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? "",
      name: map['name'] ?? "",
      kycStatus: KycStatus.convertStringToEnum(map['kycStatus'] ?? ""),
      address: map['address'] ?? "",
    );
  }
}
