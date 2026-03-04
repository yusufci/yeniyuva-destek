import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Datasource provider
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSource(Supabase.instance.client);
});

// Favoriler provider
final favoritesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.status != AuthStatus.authenticated || authState.user == null) {
    return [];
  }
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return dataSource.getFavorites(authState.user!.id);
});

// Favori kontrolü
final isFavoriteProvider = FutureProvider.family<bool, String>((ref, serviceId) async {
  final authState = ref.watch(authProvider);
  if (authState.status != AuthStatus.authenticated || authState.user == null) {
    return false;
  }
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return dataSource.isFavorite(authState.user!.id, serviceId);
});

// Profile State
class ProfileState {
  final Map<String, dynamic>? profileData;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.profileData,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    Map<String, dynamic>? profileData,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profileData: profileData ?? this.profileData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final ProfileRemoteDataSource _dataSource;

  ProfileNotifier(this._dataSource) : super(const ProfileState());

  Future<void> loadProfile(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final data = await _dataSource.getProfile(userId);
      state = state.copyWith(profileData: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateProfile({
    required String userId,
    String? username,
    String? avatarUrl,
    String? preferredLanguage,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _dataSource.updateProfile(
        userId: userId,
        username: username,
        avatarUrl: avatarUrl,
        preferredLanguage: preferredLanguage,
      );
      await loadProfile(userId);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> toggleFavorite(String userId, String serviceId) async {
    try {
      final isFav = await _dataSource.isFavorite(userId, serviceId);
      if (isFav) {
        await _dataSource.removeFavorite(userId, serviceId);
      } else {
        await _dataSource.addFavorite(userId, serviceId);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final dataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileNotifier(dataSource);
});