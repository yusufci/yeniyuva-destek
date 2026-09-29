import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingData(
      icon: Icons.home_work_rounded,
      title: 'YeniYuva\'ya Hoş Geldiniz',
      subtitle: 'Türkiye\'deki yaşamınızı kolaylaştıracak\nkişisel rehberiniz',
      color: AppColors.primary,
    ),
    _OnboardingData(
      icon: Icons.map_outlined,
      title: 'Yakınınızdaki Hizmetler',
      subtitle: 'Sağlık, eğitim, hukuki destek ve daha fazlasını\nharita üzerinde kolayca bulun',
      color: AppColors.secondary,
    ),
    _OnboardingData(
      icon: Icons.menu_book_outlined,
      title: 'Bilgi Merkezi',
      subtitle: 'Oturma izni, iş izni, eğitim sistemi gibi\nkonularda detaylı rehberler',
      color: AppColors.categoryEducation,
    ),
    _OnboardingData(
      icon: Icons.people_outline,
      title: 'Topluluk Desteği',
      subtitle: 'Deneyimlerinizi paylaşın, sorularınızı sorun\nve diğer göçmenlerle bağlantı kurun',
      color: AppColors.categoryCommunity,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() {
    context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Dil seçimi (üst bar)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Atla butonu
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _completeOnboarding,
                      child: Text(
                        'Atla',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  else
                    const SizedBox(width: 60),
                  // Dil seçimi
                  PopupMenuButton<String>(
                    onSelected: (code) {
                      ref.read(localeProvider.notifier).setLanguageCode(code);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'tr', child: Text('🇹🇷 Türkçe')),
                      const PopupMenuItem(value: 'ar', child: Text('🇸🇦 العربية')),
                      const PopupMenuItem(value: 'en', child: Text('🇬🇧 English')),
                      const PopupMenuItem(value: 'fa', child: Text('🇮🇷 فارسی')),
                      const PopupMenuItem(value: 'uk', child: Text('🇺🇦 Українська')),
                      const PopupMenuItem(value: 'ru', child: Text('🇷🇺 Русский')),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.textHint),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language, size: 18, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            _getLanguageEmoji(ref.watch(localeProvider).languageCode),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Sayfa içeriği
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPage(context, page);
                },
              ),
            ),
            // Alt navigasyon
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Sayfa göstergeleri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive ? _pages[_currentPage].color : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  // Butonlar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _pages[_currentPage].color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Başlayalım!' : 'Devam',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (_currentPage == _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.goNamed('login'),
                      child: Text(
                        'Zaten hesabım var',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, _OnboardingData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 70,
              color: page.color,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getLanguageEmoji(String code) {
    switch (code) {
      case 'tr': return '🇹🇷';
      case 'ar': return '🇸🇦';
      case 'en': return '🇬🇧';
      case 'fa': return '🇮🇷';
      case 'uk': return '🇺🇦';
      case 'ru': return '🇷🇺';
      default: return '🌐';
    }
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}