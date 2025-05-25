class UserModel {
  final String uid;
  final String email;
  final String? username;
  final String? phone;

  UserModel({
    required this.uid,
    required this.email,
    this.username,
    this.phone,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      username: map['username'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phone': phone,
    };
  }
}
