import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/forum_remote_datasource.dart';
import '../../domain/entities/thread_entity.dart';

// Datasource provider
final forumRemoteDataSourceProvider = Provider<ForumRemoteDataSource>((ref) {
  return ForumRemoteDataSource(Supabase.instance.client);
});

// Forum State
class ForumState {
  final List<ThreadEntity> threads;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;

  const ForumState({
    this.threads = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
  });

  ForumState copyWith({
    List<ThreadEntity>? threads,
    bool? isLoading,
    String? error,
    String? selectedCategory,
  }) {
    return ForumState(
      threads: threads ?? this.threads,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

// Forum Notifier
class ForumNotifier extends StateNotifier<ForumState> {
  final ForumRemoteDataSource _dataSource;

  ForumNotifier(this._dataSource) : super(const ForumState()) {
    loadThreads();
  }

  Future<void> loadThreads({String? category}) async {
    state = state.copyWith(isLoading: true, selectedCategory: category);
    try {
      final threads = await _dataSource.getThreads(category: category);
      state = state.copyWith(threads: threads, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> createThread({
    required String title,
    required String body,
    String? category,
  }) async {
    try {
      final thread = await _dataSource.createThread(
        title: title,
        body: body,
        category: category,
      );
      state = state.copyWith(threads: [thread, ...state.threads]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setCategory(String? category) {
    loadThreads(category: category);
  }

  Future<void> refresh() async {
    await loadThreads(category: state.selectedCategory);
  }
}

// Providers
final forumProvider = StateNotifierProvider<ForumNotifier, ForumState>((ref) {
  final dataSource = ref.watch(forumRemoteDataSourceProvider);
  return ForumNotifier(dataSource);
});

// Thread detail
final threadDetailProvider = FutureProvider.family<ThreadEntity, String>((ref, id) async {
  final dataSource = ref.watch(forumRemoteDataSourceProvider);
  return dataSource.getThreadById(id);
});

// Thread posts
final threadPostsProvider = FutureProvider.family<List<PostEntity>, String>((ref, threadId) async {
  final dataSource = ref.watch(forumRemoteDataSourceProvider);
  return dataSource.getPostsByThread(threadId);
});