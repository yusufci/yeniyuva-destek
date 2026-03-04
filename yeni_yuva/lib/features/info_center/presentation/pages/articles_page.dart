import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_display_widget.dart';
import '../providers/article_provider.dart';

class ArticlesPage extends ConsumerWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(allArticlesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Bilgi Merkezi',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Arama sayfası
            },
          ),
        ],
      ),
      body: articlesAsync.when(
        loading: () => const LoadingWidget(message: 'Makaleler yükleniyor...'),
        error: (error, _) => ErrorDisplayWidget(
          message: 'Makaleler yüklenemedi',
          details: error.toString(),
          onRetry: () => ref.invalidate(allArticlesProvider),
        ),
        data: (articles) {
          if (articles.isEmpty) {
            return const EmptyStateWidget(
              message: 'Henüz makale bulunmuyor',
              icon: Icons.article_outlined,
            );
          }

          // Makaleleri kategorilere göre grupla
          final grouped = <String, List<dynamic>>{};
          for (final article in articles) {
            grouped.putIfAbsent(article.category, () => []).add(article);
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sizin İçin Seçilenler', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.take(3).length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            final color = _getCategoryColor(article.category);
                            return GestureDetector(
                              onTap: () => context.goNamed('article-detail', pathParameters: {'slug': article.slug}),
                              child: Container(
                                width: 280,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: color.withValues(alpha: 0.3)),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                      child: Icon(_getCategoryIcon(article.category), color: color, size: 24),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(article.getLocalizedTitle('tr'), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Text(article.getLocalizedSummary('tr'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Tüm Makaleler', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final article = articles[index];
                      final color = _getCategoryColor(article.category);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.1)),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                              child: Icon(_getCategoryIcon(article.category), size: 20, color: color),
                            ),
                            title: Text(article.getLocalizedTitle('tr'), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                            subtitle: Text('${article.viewCount} okunma', style: TextStyle(fontSize: 11, color: AppColors.textHint)),
                            trailing: Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                            onTap: () => context.goNamed('article-detail', pathParameters: {'slug': article.slug}),
                          ),
                        ),
                      );
                    },
                    childCount: articles.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'life_in_turkey': return AppColors.categoryCommunity;
      case 'education_system': return AppColors.categoryEducation;
      case 'health_system': return AppColors.categoryHealth;
      case 'work_life': return AppColors.categoryEmployment;
      case 'legal_rights': return AppColors.categoryLegal;
      default: return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'life_in_turkey': return Icons.public;
      case 'education_system': return Icons.school;
      case 'health_system': return Icons.local_hospital;
      case 'work_life': return Icons.work;
      case 'legal_rights': return Icons.gavel;
      default: return Icons.article;
    }
  }
}