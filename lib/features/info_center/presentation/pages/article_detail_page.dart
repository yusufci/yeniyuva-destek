import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_display_widget.dart';
import '../providers/article_provider.dart';

class ArticleDetailPage extends ConsumerWidget {
  final String slug;

  const ArticleDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleDetailProvider(slug));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(icon: Icon(Icons.bookmark_border, color: AppColors.textSecondary), onPressed: () {}),
          IconButton(icon: Icon(Icons.share_outlined, color: AppColors.textSecondary), onPressed: () {}),
        ],
      ),
      body: articleAsync.when(
        loading: () => const LoadingWidget(message: 'Makale yükleniyor...'),
        error: (error, _) => ErrorDisplayWidget(
          message: 'Makale yüklenemedi',
          details: error.toString(),
          onRetry: () => ref.invalidate(articleDetailProvider(slug)),
        ),
        data: (article) {
          final title = article.getLocalizedTitle('tr');
          final content = article.getLocalizedContent('tr');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCategoryLabel(article.category),
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(article.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.visibility_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      '${article.viewCount} Okunma',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),
                // Faydalı mıydı
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text('Bu makale faydalı oldu mu?', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.thumb_up_outlined),
                            label: const Text('Evet'),
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.success, side: BorderSide(color: AppColors.success)),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.thumb_down_outlined),
                            label: const Text('Hayır'),
                            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error, side: BorderSide(color: AppColors.error)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'life_in_turkey': return 'Türkiye\'de Yaşam';
      case 'education_system': return 'Eğitim Sistemi';
      case 'health_system': return 'Sağlık Sistemi';
      case 'work_life': return 'Çalışma Hayatı';
      case 'legal_rights': return 'Hukuki Haklar';
      default: return 'Rehber';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}