import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/welcome_header_widget.dart';
import '../../../../core/widgets/quick_tools_widget.dart';
import '../../../../core/widgets/announcement_card_widget.dart';
import '../../../../core/utils/animated_list_item.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late AnimationController _searchBarController;
  late Animation<double> _searchBarFade;
  late Animation<double> _searchBarScale;

  @override
  void initState() {
    super.initState();
    _searchBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _searchBarFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _searchBarController, curve: Curves.easeOut),
    );
    _searchBarScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _searchBarController, curve: Curves.easeOutBack),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _searchBarController.forward();
    });
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'YeniYuva',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.textSecondary),
            onPressed: () => context.goNamed('profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animasyonlu Hoşgeldin Header - gerçek kullanıcı adı
            WelcomeHeaderWidget(
              userName: ref.watch(currentUserProvider)?.username ?? 'Misafir',
            ),
            const SizedBox(height: 16),

            // Acil Durum Butonu - Staggered
            AnimatedListItem(
              index: 1,
              child: _buildEmergencyBanner(context),
            ),
            const SizedBox(height: 20),

            // Animasyonlu Arama Çubuğu
            FadeTransition(
              opacity: _searchBarFade,
              child: ScaleTransition(
                scale: _searchBarScale,
                child: _buildAnimatedSearchBar(context),
              ),
            ),
            const SizedBox(height: 24),

            // Kategoriler başlık
            AnimatedListItem(
              index: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hizmet Kategorileri',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.goNamed('map'),
                      child: Text(
                        'Haritada Gör',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildCategoryGrid(context),
            const SizedBox(height: 24),

            // Forum Banner
            AnimatedListItem(
              index: 6,
              delay: const Duration(milliseconds: 60),
              child: _buildForumBanner(context),
            ),
            const SizedBox(height: 24),

            // Kullanışlı Araçlar
            AnimatedListItem(
              index: 7,
              delay: const Duration(milliseconds: 60),
              child: const QuickToolsWidget(),
            ),
            const SizedBox(height: 24),

            // Duyurular
            AnimatedListItem(
              index: 8,
              delay: const Duration(milliseconds: 60),
              child: Padding(
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
                      onPressed: () {},
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
            ),
            const SizedBox(height: 12),
            AnimatedListItem(
              index: 9,
              delay: const Duration(milliseconds: 60),
              child: AnnouncementCardWidget(
                title: 'Türkçe Dersleri Başlıyor!',
                description: 'Ücretsiz Türkçe kurslarımız yakında başlıyor. Kayıt için tıklayın.',
                date: '15 Ocak',
                onTap: () {},
              ),
            ),
            const SizedBox(height: 12),
            AnimatedListItem(
              index: 10,
              delay: const Duration(milliseconds: 60),
              child: AnnouncementCardWidget(
                title: 'Sağlık Taraması',
                description: 'Ücretsiz sağlık taraması için randevu alabilirsiniz.',
                date: '20 Ocak',
                onTap: () {},
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onTap: () {
          // TODO: Arama sayfası
        },
        decoration: InputDecoration(
          hintText: 'Hizmet, rehber veya konu ara...',
          hintStyle: TextStyle(
            color: AppColors.textHint,
            fontSize: 15,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.search, color: AppColors.primary, size: 18),
            ),
          ),
          suffixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.tune, color: AppColors.secondary, size: 18),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildEmergencyBanner(BuildContext context) {
    return BounceWidget(
      onTap: () => context.pushNamed('emergency'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.error,
              AppColors.error.withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.emergency, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Acil Durum',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Acil numaralar ve yardım bilgileri',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid(BuildContext context) {
    final categories = [
      _CategoryItem(Icons.local_hospital, 'Sağlık', AppColors.categoryHealth, 'health'),
      _CategoryItem(Icons.school, 'Eğitim', AppColors.categoryEducation, 'education'),
      _CategoryItem(Icons.gavel, 'Hukuki\nDestek', AppColors.categoryLegal, 'legal'),
      _CategoryItem(Icons.home_work, 'Barınma', AppColors.categoryHousing, 'housing'),
      _CategoryItem(Icons.volunteer_activism, 'Sosyal\nYardım', AppColors.categorySocialAid, 'social_aid'),
      _CategoryItem(Icons.work, 'İş ve\nKariyer', AppColors.categoryEmployment, 'employment'),
      _CategoryItem(Icons.people, 'Topluluk', AppColors.categoryCommunity, 'community'),
      _CategoryItem(Icons.more_horiz, 'Tümü', AppColors.secondary, 'all'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return ScaleAnimatedWidget(
          index: index,
          delay: const Duration(milliseconds: 50),
          child: _buildCategoryItem(context, cat),
        );
      },
    );
  }

  Widget _buildCategoryItem(BuildContext context, _CategoryItem item) {
    return BounceWidget(
      onTap: () => context.goNamed('map'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item.color.withValues(alpha: 0.15),
                  item.color.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.color.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(item.icon, color: item.color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: 11,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForumBanner(BuildContext context) {
    return BounceWidget(
      onTap: () => context.pushNamed('forum'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.categoryCommunity.withValues(alpha: 0.08),
              AppColors.secondary.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.categoryCommunity.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.categoryCommunity.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.forum, color: AppColors.categoryCommunity, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topluluk Forumu',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sorularınızı sorun, deneyimlerinizi paylaşın',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.categoryCommunity.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.categoryCommunity),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem {
  final IconData icon;
  final String label;
  final Color color;
  final String category;
  _CategoryItem(this.icon, this.label, this.color, this.category);
}