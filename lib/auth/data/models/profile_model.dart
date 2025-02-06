import 'dart:convert';

import 'package:wellnest/auth/business/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel(
      {required super.id,
      required super.fullName,
      required super.email,
      required super.role});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ProfileModel.fromEntity(ProfileEntity profileEntity) => ProfileModel(
      id: profileEntity.id,
      fullName: profileEntity.fullName,
      email: profileEntity.email,
      role: profileEntity.role);
}
