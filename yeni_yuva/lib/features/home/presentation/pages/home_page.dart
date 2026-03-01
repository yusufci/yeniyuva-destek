import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YeniYuva'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              // TODO: Dil değiştirme dialog'u
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hoşgeldiniz kartı
            Card(
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.waving_hand, color: Colors.white, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Hoş Geldiniz!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'YeniYuva, Türkiye\'de yaşayan göçmenler için hizmetlere erişimi kolaylaştıran dijital rehberinizdir.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hızlı Erişim
            Text(
              'Hızlı Erişim',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildQuickAccessCard(
                  context,
                  icon: Icons.local_hospital,
                  label: 'Sağlık',
                  color: AppColors.categoryHealth,
                  onTap: () {},
                ),
                _buildQuickAccessCard(
                  context,
                  icon: Icons.school,
                  label: 'Eğitim',
                  color: AppColors.categoryEducation,
                  onTap: () {},
                ),
                _buildQuickAccessCard(
                  context,
                  icon: Icons.gavel,
                  label: 'Hukuki Destek',
                  color: AppColors.categoryLegal,
                  onTap: () {},
                ),
                _buildQuickAccessCard(
                  context,
                  icon: Icons.home,
                  label: 'Barınma',
                  color: AppColors.categoryHousing,
                  onTap: () {},
                ),
                _buildQuickAccessCard(
                  context,
                  icon: Icons.volunteer_activism,
                  label: 'Sosyal Yardım',
                  color: AppColors.categorySocialAid,
                  onTap: () {},
                ),
                _buildQuickAccessCard(
                  context,
                  icon: Icons.work,
                  label: 'İş ve Kariyer',
                  color: AppColors.categoryEmployment,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Acil Durum
            Card(
              color: AppColors.error,
              child: ListTile(
                leading: const Icon(Icons.emergency, color: Colors.white, size: 32),
                title: const Text(
                  'Acil Durum',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  '112 - Acil Yardım Hattı',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.phone, color: Colors.white),
                onTap: () {
                  // TODO: 112'yi ara
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}