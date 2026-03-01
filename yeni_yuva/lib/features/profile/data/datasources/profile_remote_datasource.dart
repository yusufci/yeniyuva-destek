import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';

class ProfileRemoteDataSource {
  final SupabaseClient _client;

  ProfileRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      throw ServerException(message: 'Profil yüklenemedi: $e');
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
    String? preferredLanguage,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (preferredLanguage != null) updates['preferred_language'] = preferredLanguage;

      await _client.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      throw ServerException(message: 'Profil güncellenemedi: $e');
    }
  }

  // Favoriler
  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    try {
      final response = await _client
          .from('favorites')
          .select('*, services(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw ServerException(message: 'Favoriler yüklenemedi: $e');
    }
  }

  Future<void> addFavorite(String userId, String serviceId) async {
    try {
      await _client.from('favorites').insert({
        'user_id': userId,
        'service_id': serviceId,
      });
    } catch (e) {
      throw ServerException(message: 'Favoriye eklenemedi: $e');
    }
  }

  Future<void> removeFavorite(String userId, String serviceId) async {
    try {
      await _client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('service_id', serviceId);
    } catch (e) {
      throw ServerException(message: 'Favori kaldırılamadı: $e');
    }
  }

  Future<bool> isFavorite(String userId, String serviceId) async {
    try {
      final response = await _client
          .from('favorites')
          .select('id')
          .eq('user_id', userId)
          .eq('service_id', serviceId)
          .maybeSingle();
      return response != null;
    } catch (_) {
      return false;
    }
  }
}