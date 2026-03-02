import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ArticleDetailPage extends StatelessWidget {
  final String slug;

  const ArticleDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    // Slug üzerinden geçici başlık oluşturma (Gerçek veriler gelene kadar)
    final title = slug.replaceAll('-', ' ').split(' ').map((e) => e.length > 1 ? '${e[0].toUpperCase()}${e.substring(1)}' : e).join(' ');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Favorilere ekle
            },
          ),
          IconButton(
            icon: Icon(Icons.share_outlined, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Paylaş
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                'Rehber',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
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
                  'Güncellenme: 02.03.2026',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.visibility_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  '1.2k Okunma',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              'Bu rehber makalesi, Türkiye\'deki yasal haklarınız ve süreçler hakkında temel bilgileri sağlamak amacıyla hazırlanmıştır. Burada yer alan bilgiler tavsiye niteliğindedir ve resmi süreçlerde değişiklik gösterebilir.\n\n'
              'Şu anda görüntülediğiniz sayfa (slug: $slug) için veritabanı bağlantısı yapıldığında gerçek içerikler Markdown veya Zengin Metin (Rich Text) formatında burada listelenecektir.\n\n'
              'Önemli Not:\nLütfen resmi başvurularınızı yapmadan önce yetkili kurumların resmi web sitelerini (örn: Göç İdaresi Başkanlığı) ziyaret ederek güncel bilgileri teyit ediniz.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 40),
            // Faydalı mıydı bölümü
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Bu makale faydalı oldu mu?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_up_outlined),
                        label: const Text('Evet'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.success,
                          side: BorderSide(color: AppColors.success),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_down_outlined),
                        label: const Text('Hayır'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}