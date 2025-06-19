// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String? profilePictureUrl;
  final String? statusMessage;

  User({required this.id, required this.name, this.profilePictureUrl, this.statusMessage});
}