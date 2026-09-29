import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.content,
    super.summary,
    required super.category,
    required super.slug,
    super.coverImageUrl,
    super.isPublished,
    super.viewCount,
    required super.createdAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] as String,
      title: _parseJsonb(json['title']),
      content: _parseJsonb(json['content']),
      summary: json['summary'] != null ? _parseJsonb(json['summary']) : null,
      category: json['category'] as String,
      slug: json['slug'] as String,
      coverImageUrl: json['cover_image_url'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      viewCount: json['view_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static Map<String, String> _parseJsonb(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return {};
  }
}

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> getArticles({String? category});
  Future<ArticleModel> getArticleBySlug(String slug);
  Future<List<ArticleModel>> searchArticles(String query);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final SupabaseClient _client;

  ArticleRemoteDataSourceImpl(this._client);

  @override
  Future<List<ArticleModel>> getArticles({String? category}) async {
    try {
      var query = _client.from('articles').select().eq('is_published', true);

      if (category != null) {
        query = query.eq('category', category);
      }

      final response = await query.order('created_at', ascending: false);

      return (response as List)
          .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Makaleler yüklenemedi: $e');
    }
  }

  @override
  Future<ArticleModel> getArticleBySlug(String slug) async {
    try {
      final response = await _client
          .from('articles')
          .select()
          .eq('slug', slug)
          .eq('is_published', true)
          .single();

      return ArticleModel.fromJson(response);
    } catch (e) {
      throw ServerException(message: 'Makale bulunamadı: $e');
    }
  }

  @override
  Future<List<ArticleModel>> searchArticles(String query) async {
    try {
      final response = await _client
          .from('articles')
          .select()
          .eq('is_published', true)
          .or('title->>tr.ilike.%$query%,title->>en.ilike.%$query%,title->>ar.ilike.%$query%')
          .limit(20);

      return (response as List)
          .map((json) => ArticleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Arama sırasında hata: $e');
    }
  }
}