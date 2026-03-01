import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/forum_remote_datasource.dart';
import '../../domain/entities/thread_entity.dart';

final forumDataSourceProvider = Provider<ForumRemoteDataSource>((ref) {
  return ForumRemoteDataSource(Supabase.instance.client);
});

final threadsProvider = FutureProvider.family<List<ThreadEntity>, String?>((ref, category) async {
  final ds = ref.watch(forumDataSourceProvider);
  return ds.getThreads(category: category);
});

final threadDetailProvider = FutureProvider.family<ThreadEntity, String>((ref, id) async {
  final ds = ref.watch(forumDataSourceProvider);
  return ds.getThreadById(id);
});

final threadPostsProvider = FutureProvider.family<List<PostEntity>, String>((ref, threadId) async {
  final ds = ref.watch(forumDataSourceProvider);
  return ds.getPostsByThread(threadId);
});

final threadPostsStreamProvider = StreamProvider.family<List<PostEntity>, String>((ref, threadId) {
  final ds = ref.watch(forumDataSourceProvider);
  return ds.watchPosts(threadId);
});