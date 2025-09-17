import 'dart:ffi';

import 'package:tcc/core/enum/kyc_status.dart';
import 'package:tcc/core/models/user_document.dart';

class UserModel {
  String? id;
  final String name;
  final String email;
  final String? address;
  final bool? isAdmin;
  KycStatus kycStatus;

  UserModel({
    required this.name,
    required this.email,
    required this.kycStatus,
    this.isAdmin = false,
    this.address,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "email": email,
      "address": address,
      "kycStatus": kycStatus.name,
      "isAdmin": isAdmin,
      "id": id
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? "",
      name: map['name'] ?? "",
      kycStatus: KycStatus.convertStringToEnum(map['kycStatus'] ?? ""),
      address: map['address'] ?? "",
      isAdmin: map['isAdmin'] ?? false,
      id: map['id'] ?? "",
    );
  }
}
