import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(client);
});

// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

// Auth state
enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState()) {
    _init();
  }

  Future<void> _init() async {
    final result = await _repository.getCurrentUser();
    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.unauthenticated),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _repository.signInWithEmail(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signUpWithEmail(String email, String password, String username) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _repository.signUpWithEmail(
      email: email,
      password: password,
      username: username,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _repository.signInWithGoogle();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _repository.signOut();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = const AuthState(status: AuthStatus.unauthenticated),
    );
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

// Convenience providers
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});

final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authProvider).user;
});