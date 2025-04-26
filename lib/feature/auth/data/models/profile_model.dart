import 'dart:convert';

import 'package:wellnest/feature/auth/business/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.role,
    required super.avatarUrl,
    required super.occupation,
    required super.city,
    required super.description,
    required super.goals,
    required super.interests,
    required super.karma,
    required super.latitude,
    required super.longitude,
  });

  factory ProfileModel.fromEntity(ProfileEntity entity) {
    return ProfileModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      role: entity.role,
      avatarUrl: entity.avatarUrl,
      occupation: entity.occupation,
      city: entity.city,
      description: entity.description,
      goals: entity.goals,
      interests: entity.interests,
      karma: entity.karma,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
      avatarUrl: avatarUrl,
      occupation: occupation,
      city: city,
      description: description,
      goals: goals,
      interests: interests,
      karma: karma,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'avatarUrl': avatarUrl,
      'occupation': occupation,
      'city': city,
      'description': description,
      'goals': goals,
      'interests': interests,
      'karma': karma,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      role: map['role'] as String,
      avatarUrl: map['avatarUrl'] as String,
      occupation:
          map['occupation'] != null ? map['occupation'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      goals: List<String>.from((map['goals'] as List<String>)),
      interests: List<String>.from((map['interests'] as List<String>)),
      karma: map['karma'] as int,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) =>
      ProfileModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
