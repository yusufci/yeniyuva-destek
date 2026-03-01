import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/thread_entity.dart';

class ThreadModel extends ThreadEntity {
  const ThreadModel({
    required super.id,
    required super.title,
    required super.body,
    super.category,
    required super.authorId,
    super.authorName,
    super.voteCount,
    super.replyCount,
    super.isLocked,
    super.isPinned,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    return ThreadModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      category: json['category'] as String?,
      authorId: json['author_id'] as String,
      authorName: (json['profiles'] as Map<String, dynamic>?)?['username'] as String?,
      voteCount: json['vote_count'] as int? ?? 0,
      replyCount: json['reply_count'] as int? ?? 0,
      isLocked: json['is_locked'] as bool? ?? false,
      isPinned: json['is_pinned'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.body,
    required super.threadId,
    required super.authorId,
    super.authorName,
    super.voteCount,
    required super.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      body: json['body'] as String,
      threadId: json['thread_id'] as String,
      authorId: json['author_id'] as String,
      authorName: (json['profiles'] as Map<String, dynamic>?)?['username'] as String?,
      voteCount: json['vote_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class ForumRemoteDataSource {
  final SupabaseClient _client;

  ForumRemoteDataSource(this._client);

  Future<List<ThreadModel>> getThreads({String? category, int limit = 20, int offset = 0}) async {
    try {
      var query = _client
          .from('forum_threads')
          .select('*, profiles(username)')
          .order('is_pinned', ascending: false)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      if (category != null) {
        query = query.eq('category', category);
      }

      final response = await query;
      return (response as List).map((j) => ThreadModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException(message: 'Forum başlıkları yüklenemedi: $e');
    }
  }

  Future<ThreadModel> getThreadById(String id) async {
    try {
      final response = await _client
          .from('forum_threads')
          .select('*, profiles(username)')
          .eq('id', id)
          .single();
      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Başlık bulunamadı: $e');
    }
  }

  Future<List<PostModel>> getPostsByThread(String threadId) async {
    try {
      final response = await _client
          .from('forum_posts')
          .select('*, profiles(username)')
          .eq('thread_id', threadId)
          .order('created_at', ascending: true);

      return (response as List).map((j) => PostModel.fromJson(j as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException(message: 'Yanıtlar yüklenemedi: $e');
    }
  }

  Future<ThreadModel> createThread({required String title, required String body, String? category}) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final response = await _client.from('forum_threads').insert({
        'title': title,
        'body': body,
        'category': category,
        'author_id': userId,
      }).select('*, profiles(username)').single();

      return ThreadModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Başlık oluşturulamadı: $e');
    }
  }

  Future<PostModel> createPost({required String threadId, required String body}) async {
    try {
      final userId = _client.auth.currentUser!.id;
      final response = await _client.from('forum_posts').insert({
        'body': body,
        'thread_id': threadId,
        'author_id': userId,
      }).select('*, profiles(username)').single();

      return PostModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Yanıt gönderilemedi: $e');
    }
  }

  Stream<List<PostModel>> watchPosts(String threadId) {
    return _client
        .from('forum_posts')
        .stream(primaryKey: ['id'])
        .eq('thread_id', threadId)
        .order('created_at', ascending: true)
        .map((data) => data.map((j) => PostModel.fromJson(j)).toList());
  }
}