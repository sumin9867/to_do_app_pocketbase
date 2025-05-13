// lib/features/auth/data/models/user_model.dart
class UserModel {
  final String id;
  final String email;
  final String name;
  final String created;
  final String updated;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.created,
    required this.updated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      created: json['created'] ?? '',
      updated: json['updated'] ?? '',
    );
  }
}
