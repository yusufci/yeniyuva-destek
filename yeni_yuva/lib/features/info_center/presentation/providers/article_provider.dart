import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/article_remote_datasource.dart';
import '../../domain/entities/article_entity.dart';

// Datasource provider
final articleRemoteDataSourceProvider = Provider<ArticleRemoteDataSource>((ref) {
  return ArticleRemoteDataSourceImpl(Supabase.instance.client);
});

// Articles by category
final articlesByCategoryProvider = FutureProvider.family<List<ArticleEntity>, String?>((ref, category) async {
  final dataSource = ref.watch(articleRemoteDataSourceProvider);
  return dataSource.getArticles(category: category);
});

// All articles
final allArticlesProvider = FutureProvider<List<ArticleEntity>>((ref) async {
  final dataSource = ref.watch(articleRemoteDataSourceProvider);
  return dataSource.getArticles();
});

// Article detail by slug
final articleDetailProvider = FutureProvider.family<ArticleEntity, String>((ref, slug) async {
  final dataSource = ref.watch(articleRemoteDataSourceProvider);
  return dataSource.getArticleBySlug(slug);
});

// Search articles
final articleSearchProvider = FutureProvider.family<List<ArticleEntity>, String>((ref, query) async {
  final dataSource = ref.watch(articleRemoteDataSourceProvider);
  return dataSource.searchArticles(query);
});