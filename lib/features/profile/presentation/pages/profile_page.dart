import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.status == AuthStatus.authenticated;
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profil',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.error),
              onPressed: () {
                _showLogoutDialog(context, ref);
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profil kartı
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.primary.withValues(alpha: 0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      isAuthenticated ? Icons.person : Icons.person_outline,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isAuthenticated ? (user?.username ?? 'Kullanıcı') : 'Misafir Kullanıcı',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAuthenticated
                        ? (user?.email ?? '')
                        : 'Giriş yaparak tüm özelliklere erişin',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (!isAuthenticated) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.pushNamed('login'),
                        child: const Text('Giriş Yap / Kayıt Ol'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Ayarlar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Ayarlar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Dil'),
                  subtitle: Text(_getLanguageName(ref.watch(localeProvider).languageCode)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showLanguageDialog(context, ref);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Tema'),
                  subtitle: const Text('Sistem'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Bildirimler'),
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Hakkında
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Hakkında',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Uygulama Hakkında'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Gizlilik Politikası'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Kullanım Şartları'),
                  onTap: () {},
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.code),
                  title: Text('Versiyon'),
                  subtitle: Text('1.0.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'tr': return 'Türkçe';
      case 'ar': return 'العربية';
      case 'en': return 'English';
      case 'fa': return 'فارسی';
      case 'uk': return 'Українська';
      case 'ru': return 'Русский';
      default: return code;
    }
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).signOut();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.read(localeProvider);
    
    final languages = [
      {'code': 'tr', 'flag': '🇹🇷', 'name': 'Türkçe'},
      {'code': 'ar', 'flag': '🇸🇦', 'name': 'العربية'},
      {'code': 'en', 'flag': '🇬🇧', 'name': 'English'},
      {'code': 'fa', 'flag': '🇮🇷', 'name': 'فارسی'},
      {'code': 'uk', 'flag': '🇺🇦', 'name': 'Українська'},
      {'code': 'ru', 'flag': '🇷🇺', 'name': 'Русский'},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Dil Seçin'),
          children: languages.map((lang) {
            final isSelected = currentLocale.languageCode == lang['code'];
            return SimpleDialogOption(
              onPressed: () {
                ref.read(localeProvider.notifier).setLanguageCode(lang['code']!);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text(lang['flag']!, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      lang['name']!,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}