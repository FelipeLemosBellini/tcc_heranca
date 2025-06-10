class UserModel {
  final String uid;
  final String name;
  final String email;
  final String address;
  double balance;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.balance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "uid": uid,
      "name": name,
      "email": email,
      "address": address,
      "balance": balance,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? "",
      email: map['email'] ?? "",
      name: map['name'] ?? "",
      address: map['address'] ?? "",
      balance: map['balance']?.toDouble() ?? 0.0,
    );
  }
}
