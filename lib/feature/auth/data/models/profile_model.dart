import 'dart:convert';

import 'package:wellnest/feature/auth/business/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel(
      {required super.id,
      required super.fullName,
      required super.email,
      required super.role,
      required super.avatarUrl});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullName,
      'email': email,
      'role': role,
      'avatar_url': avatarUrl,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      fullName: map['fullname'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      avatarUrl: map['avatar_url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory ProfileModel.fromEntity(ProfileEntity profileEntity) => ProfileModel(
      id: profileEntity.id,
      fullName: profileEntity.fullName,
      email: profileEntity.email,
      role: profileEntity.role,
      avatarUrl: profileEntity.avatarUrl);
}
