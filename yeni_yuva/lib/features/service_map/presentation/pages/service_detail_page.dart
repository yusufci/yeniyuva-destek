import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ServiceDetailPage extends StatelessWidget {
  final String serviceId;

  const ServiceDetailPage({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: AppColors.textSecondary),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Harita / Görsel Alanı (Placeholder)
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: Image.network(
                'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg',
                fit: BoxFit.cover,
              ),
            ),
            
            // Detay Kartı
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.categoryHealth.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Sağlık',
                            style: TextStyle(
                              color: AppColors.categoryHealth,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.circle, size: 8, color: AppColors.success),
                              const SizedBox(width: 4),
                              Text(
                                'Açık',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Örnek Göçmen Sağlığı Merkezi',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bu sağlık merkezi, göçmenlere ücretsiz temel sağlık hizmetleri ve danışmanlık sunmaktadır.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    _buildInfoRow(Icons.location_on_outlined, 'Adres', 'Fatih Mahallesi, Göçmen Caddesi No:123, İstanbul'),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.phone_outlined, 'İletişim', '+90 212 123 45 67\ninfo@ornekmerkez.org'),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.access_time_outlined, 'Çalışma Saatleri', 'Pazartesi - Cuma: 09:00 - 17:00\nHafta sonu kapalı'),
                    const SizedBox(height: 16),
                    _buildInfoRow(Icons.language_outlined, 'Desteklenen Diller', 'Türkçe, Arapça, İngilizce, Farsça'),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Ara
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('Ara'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Rota oluştur
                            },
                            icon: const Icon(Icons.directions),
                            label: const Text('Yol Tarifi Al'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}