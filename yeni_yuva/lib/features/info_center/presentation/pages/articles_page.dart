import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Bilgi Merkezi',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () {
              // TODO: Arama
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sizin İçin Seçilenler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFeaturedCard(
                          context,
                          'Acil Durum Rehberi',
                          'Acil durumlarda aranacak numaralar ve yapılması gerekenler.',
                          Icons.warning_amber_rounded,
                          AppColors.error,
                        ),
                        const SizedBox(width: 12),
                        _buildFeaturedCard(
                          context,
                          'Ücretsiz Sağlık Hizmetleri',
                          'Göçmenler için ücretsiz sağlık hizmeti veren kurumlar.',
                          Icons.medical_services_outlined,
                          AppColors.categoryHealth,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Kategoriler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildCategorySection(context, 'Türkiye\'de Yaşam', Icons.public, AppColors.categoryCommunity, [
                  'Oturma İzni Nasıl Alınır?',
                  'Bankacılık İşlemleri Rehberi',
                  'Ulaşım Sistemi Hakkında',
                ]),
                _buildCategorySection(context, 'Eğitim Sistemi', Icons.school, AppColors.categoryEducation, [
                  'Okul Kaydı Nasıl Yapılır?',
                  'Denklik İşlemleri',
                  'Burs Olanakları',
                ]),
                _buildCategorySection(context, 'Sağlık Sistemi', Icons.local_hospital, AppColors.categoryHealth, [
                  'Randevu Alma Rehberi',
                  'Acil Servis Bilgileri',
                  'Sağlık Sigortası',
                ]),
                _buildCategorySection(context, 'Çalışma Hayatı', Icons.work, AppColors.categoryEmployment, [
                  'Çalışma İzni Nasıl Alınır?',
                  'İş Arama Yöntemleri',
                  'İşçi Hakları',
                ]),
                _buildCategorySection(context, 'Hukuki Haklar', Icons.gavel, AppColors.categoryLegal, [
                  'Mülteci Statüsü Nedir?',
                  'Hak ve Yükümlülükler',
                  'Hukuki Danışmanlık',
                ]),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, String title, String desc, IconData icon, Color color) {
    return Container(
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title, IconData icon, Color color, List<String> articles) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...articles.map((article) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.1)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    article,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                  onTap: () {
                    // Slug oluşturma (Geçici)
                    final slug = article.toLowerCase().replaceAll(' ', '-').replaceAll('?', '');
                    context.goNamed('article-detail', pathParameters: {'slug': slug});
                  },
                ),
              ),
            )),
        const SizedBox(height: 24),
      ],
    );
  }
}