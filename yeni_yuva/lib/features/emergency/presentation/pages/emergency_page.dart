import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  Future<void> _makeCall(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Acil Durum',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Uyarı Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.error,
                    AppColors.error.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.emergency, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'Acil bir durumda mısınız?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hayatınız tehlikedeyse hemen 112\'yi arayın',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _makeCall('112'),
                      icon: const Icon(Icons.phone, color: AppColors.error),
                      label: const Text(
                        '112 ARA',
                        style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Acil Numaralar
            Text(
              'Acil Numaralar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildEmergencyCard(
              context,
              icon: Icons.local_hospital,
              title: 'Ambulans',
              number: '112',
              color: AppColors.error,
              description: 'Tıbbi acil durum',
            ),
            const SizedBox(height: 8),
            _buildEmergencyCard(
              context,
              icon: Icons.local_fire_department,
              title: 'İtfaiye',
              number: '110',
              color: Colors.orange,
              description: 'Yangın ve kurtarma',
            ),
            const SizedBox(height: 8),
            _buildEmergencyCard(
              context,
              icon: Icons.local_police,
              title: 'Polis',
              number: '155',
              color: AppColors.secondary,
              description: 'Asayiş ve güvenlik',
            ),
            const SizedBox(height: 8),
            _buildEmergencyCard(
              context,
              icon: Icons.shield,
              title: 'Jandarma',
              number: '156',
              color: Colors.green.shade700,
              description: 'Kırsal bölge güvenlik',
            ),
            const SizedBox(height: 8),
            _buildEmergencyCard(
              context,
              icon: Icons.support_agent,
              title: 'ALO 182 - Göç İdaresi',
              number: '182',
              color: AppColors.categoryLegal,
              description: 'Göçmen danışma hattı',
            ),
            const SizedBox(height: 8),
            _buildEmergencyCard(
              context,
              icon: Icons.people,
              title: 'ALO 183 - Sosyal Destek',
              number: '183',
              color: AppColors.categorySocialAid,
              description: 'Sosyal destek hattı',
            ),
            const SizedBox(height: 8),
            _buildEmergencyCard(
              context,
              icon: Icons.woman,
              title: 'ALO 183 - Kadın Destek',
              number: '183',
              color: Colors.pink,
              description: 'Kadına yönelik şiddet acil destek',
            ),
            const SizedBox(height: 24),

            // Önemli Bilgiler
            Text(
              'Önemli Bilgiler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              title: 'Arama sırasında',
              items: [
                'Sakin olun ve net konuşun',
                'Konumunuzu belirtin (adres, yakın yer isimleri)',
                'Ne olduğunu kısaca anlatın',
                'Türkçe konuşamıyorsanız "Yabancı/Foreign" deyin',
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              context,
              title: 'Haklarınız',
              items: [
                'Acil sağlık hizmeti herkes için ücretsizdir',
                'Yasal statünüz ne olursa olsun acil yardım hakkınız var',
                'Tercüman talep edebilirsiniz',
                'Kimlik belgenizi yanınızda bulundurun',
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String number,
    required Color color,
    required String description,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        trailing: ElevatedButton(
          onPressed: () => _makeCall(number),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            number,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required List<String> items}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 16, color: AppColors.success),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}