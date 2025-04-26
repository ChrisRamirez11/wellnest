// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileEntity {
  String id;
  String fullName;
  String email;
  String role;
  String avatarUrl;
  String? occupation;
  String? city;
  String? description;
  List<String>? goals;
  List<String>? interests;
  int? karma;
  double? latitude;
  double? longitude;

  ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.occupation,
    required this.city,
    required this.description,
    required this.goals,
    required this.interests,
    required this.karma,
    required this.latitude,
    required this.longitude,
  });
}
