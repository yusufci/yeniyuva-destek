import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.email,
    super.username,
    super.avatarUrl,
    super.preferredLanguage,
    required super.createdAt,
  });

  factory UserModel.fromSupabaseUser(User user, Map<String, dynamic>? profile) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: profile?['username'] as String?,
      avatarUrl: profile?['avatar_url'] as String?,
      preferredLanguage: (profile?['preferred_language'] as String?) ?? 'tr',
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      username: json['username'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      preferredLanguage: (json['preferred_language'] as String?) ?? 'tr',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'preferred_language': preferredLanguage,
      'created_at': createdAt.toIso8601String(),
    };
  }
}