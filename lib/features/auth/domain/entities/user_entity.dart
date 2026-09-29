class UserEntity {
  final String id;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String preferredLanguage;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    this.email,
    this.username,
    this.avatarUrl,
    this.preferredLanguage = 'tr',
    required this.createdAt,
  });
}