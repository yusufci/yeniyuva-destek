import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail(String email, String password);
  Future<UserModel> signUpWithEmail(String email, String password, String username);
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> authStateChanges();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthException(message: 'Giriş başarısız');
      }

      final profile = await _getProfile(response.user!.id);
      return UserModel.fromSupabaseUser(response.user!, profile);
    } on AuthApiException catch (e) {
      throw AuthException(message: _mapAuthError(e.message));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail(String email, String password, String username) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      if (response.user == null) {
        throw const AuthException(message: 'Kayıt başarısız');
      }

      final profile = await _getProfile(response.user!.id);
      return UserModel.fromSupabaseUser(response.user!, profile);
    } on AuthApiException catch (e) {
      throw AuthException(message: _mapAuthError(e.message));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.yeniyuva.yeniyuva://login-callback',
      );

      // OAuth sonrası kullanıcı bilgisi
      final user = _client.auth.currentUser;
      if (user == null) {
        throw const AuthException(message: 'Google ile giriş başarısız');
      }

      final profile = await _getProfile(user.id);
      return UserModel.fromSupabaseUser(user, profile);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final profile = await _getProfile(user.id);
      return UserModel.fromSupabaseUser(user, profile);
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _client.auth.onAuthStateChange.asyncMap((data) async {
      final user = data.session?.user;
      if (user == null) return null;

      final profile = await _getProfile(user.id);
      return UserModel.fromSupabaseUser(user, profile);
    });
  }

  Future<Map<String, dynamic>?> _getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (_) {
      return null;
    }
  }

  String _mapAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'E-posta veya şifre hatalı';
    }
    if (message.contains('Email not confirmed')) {
      return 'E-posta adresinizi doğrulayın';
    }
    if (message.contains('User already registered')) {
      return 'Bu e-posta adresi zaten kayıtlı';
    }
    if (message.contains('Password should be at least')) {
      return 'Şifre en az 6 karakter olmalı';
    }
    return message;
  }
}