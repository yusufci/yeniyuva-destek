import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/welcome_header_widget.dart';
import '../../../../core/widgets/search_bar_widget.dart';
import '../../../../core/widgets/category_card_widget.dart';
import '../../../../core/widgets/quick_tools_widget.dart';
import '../../../../core/widgets/announcement_card_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'YeniYuva',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              // TODO: Bildirimler
            },
          ),
          IconButton(
            icon: Icon(
              Icons.language,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              // TODO: Dil değiştirme
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hoşgeldin Header
            const WelcomeHeaderWidget(
              userName: 'Anna',
            ),
            const SizedBox(height: 20),

            // Arama Çubuğu
            SearchBarWidget(
              hintText: 'Arama yap...',
              onTap: () {
                // TODO: Arama sayfası
              },
            ),
            const SizedBox(height: 24),

            // Kategoriler
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Hizmet Kategorileri',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            CategoryCardWidget(
              icon: Icons.shopping_bag_outlined,
              label: 'Gıda Yardımı',
              backgroundColor: AppColors.categorySocialAid,
              onTap: () {
                // TODO: Gıda yardımı sayfası
              },
            ),
            const SizedBox(height: 12),
            CategoryCardWidget(
              icon: Icons.home_outlined,
              label: 'Konaklama',
              backgroundColor: AppColors.categoryHousing,
              onTap: () {
                // TODO: Konaklama sayfası
              },
            ),
            const SizedBox(height: 12),
            CategoryCardWidget(
              icon: Icons.work_outline,
              label: 'İş ve Eğitim',
              backgroundColor: AppColors.categoryEmployment,
              onTap: () {
                // TODO: İş ve eğitim sayfası
              },
            ),
            const SizedBox(height: 12),
            CategoryCardWidget(
              icon: Icons.school_outlined,
              label: 'Dil Öğren',
              backgroundColor: AppColors.categoryEducation,
              onTap: () {
                // TODO: Dil öğrenme sayfası
              },
            ),
            const SizedBox(height: 24),

            // Kullanışlı Araçlar
            const QuickToolsWidget(),
            const SizedBox(height: 24),

            // Duyurular & Etkinlikler
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Duyurular & Etkinlikler',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Tüm duyurular sayfasına git
                    },
                    child: Text(
                      'Tümünü Gör',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AnnouncementCardWidget(
              title: 'Türkçe Dersleri Başlıyor!',
              description: 'Ücretsiz Türkçe kurslarımız yakında başlıyor. Kayıt için tıklayın.',
              date: '15 Ocak',
              onTap: () {
                // TODO: Duyuru detayı
              },
            ),
            const SizedBox(height: 12),
            AnnouncementCardWidget(
              title: 'Sağlık Taraması',
              description: 'Ücretsiz sağlık taraması için randevu alabilirsiniz.',
              date: '20 Ocak',
              onTap: () {
                // TODO: Duyuru detayı
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}