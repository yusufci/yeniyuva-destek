import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/animated_list_item.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceId;

  const ServiceDetailPage({super.key, required this.serviceId});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;
  bool _isFavorite = false;

  late AnimationController _fabController;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOutBack),
    );
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _fabController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageHeight = 260.0;
    final parallaxOffset = _scrollOffset * 0.4;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Paralaks AppBar
              SliverAppBar(
                expandedHeight: imageHeight,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                foregroundColor: _scrollOffset > imageHeight - 100
                    ? AppColors.textPrimary
                    : Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Paralaks görsel
                      Transform.translate(
                        offset: Offset(0, parallaxOffset),
                        child: Image.network(
                          'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/pass/GoogleMapTA.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                      // Alt bilgi
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.categoryHealth,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Sağlık',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Örnek Göçmen Sağlığı Merkezi',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                shadows: [Shadow(color: Colors.black38, blurRadius: 8)],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  // Animated favorite button
                  IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(_isFavorite),
                        color: _isFavorite ? AppColors.error : (_scrollOffset > imageHeight - 100 ? AppColors.textSecondary : Colors.white),
                      ),
                    ),
                    onPressed: () => setState(() => _isFavorite = !_isFavorite),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: _scrollOffset > imageHeight - 100 ? AppColors.textSecondary : Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              // İçerik
              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Durum ve mesafe
                        AnimatedListItem(
                          index: 0,
                          child: Row(
                            children: [
                              _buildStatusChip('Açık', AppColors.success, Icons.circle),
                              const SizedBox(width: 12),
                              _buildStatusChip('2.3 km', AppColors.secondary, Icons.location_on),
                              const Spacer(),
                              _buildRatingChip(4.5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Açıklama
                        AnimatedListItem(
                          index: 1,
                          child: Text(
                            'Bu sağlık merkezi, göçmenlere ücretsiz temel sağlık hizmetleri ve danışmanlık sunmaktadır.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedListItem(
                          index: 2,
                          child: const Divider(),
                        ),
                        const SizedBox(height: 24),
                        // Bilgi satırları
                        AnimatedListItem(
                          index: 3,
                          child: _buildInfoRow(Icons.location_on_outlined, 'Adres', 'Fatih Mahallesi, Göçmen Caddesi No:123, İstanbul'),
                        ),
                        const SizedBox(height: 20),
                        AnimatedListItem(
                          index: 4,
                          child: _buildInfoRow(Icons.phone_outlined, 'İletişim', '+90 212 123 45 67\ninfo@ornekmerkez.org'),
                        ),
                        const SizedBox(height: 20),
                        AnimatedListItem(
                          index: 5,
                          child: _buildInfoRow(Icons.access_time_outlined, 'Çalışma Saatleri', 'Pazartesi - Cuma: 09:00 - 17:00\nHafta sonu kapalı'),
                        ),
                        const SizedBox(height: 20),
                        AnimatedListItem(
                          index: 6,
                          child: _buildInfoRow(Icons.language_outlined, 'Desteklenen Diller', 'Türkçe, Arapça, İngilizce, Farsça'),
                        ),
                        const SizedBox(height: 32),
                        // Butonlar
                        AnimatedListItem(
                          index: 7,
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.phone),
                                  label: const Text('Ara'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.directions),
                                  label: const Text('Yol Tarifi Al'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    elevation: 4,
                                    shadowColor: AppColors.primary.withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            rating.toString(),
            style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
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
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.primary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
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