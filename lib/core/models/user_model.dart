class UserModel {
  final String name;
  final String email;

  UserModel({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "email": email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? "",
      name: map['name'] ?? "",
    );
  }
}
