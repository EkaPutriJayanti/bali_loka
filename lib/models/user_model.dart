import 'package:flutter/foundation.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? username;
  final String? phone;
  final String? photoUrl;

  UserModel({
    required this.uid,
    this.email,
    this.username,
    this.phone,
    this.photoUrl,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? phone,
    String? photoUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: map['email'] as String?,
      username: map['username'] as String?,
      phone: map['phone'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phone': phone,
      'photoUrl': photoUrl,
    };
  }
}
