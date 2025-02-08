// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProfileEntity {
  String id;
  String fullName;
  String email;
  String role;
  String avatarUrl;

  ProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.avatarUrl,
  });
}
