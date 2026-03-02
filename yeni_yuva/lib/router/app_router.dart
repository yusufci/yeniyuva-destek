import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/service_map/presentation/pages/map_page.dart';
import '../features/service_map/presentation/pages/service_detail_page.dart';
import '../features/info_center/presentation/pages/articles_page.dart';
import '../features/info_center/presentation/pages/article_detail_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/forum/presentation/pages/forum_page.dart';
import '../features/emergency/presentation/pages/emergency_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../core/widgets/main_scaffold.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      // Ana Shell (Bottom Navigation)
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/map',
            name: 'map',
            builder: (context, state) => const MapPage(),
            routes: [
              GoRoute(
                path: 'service/:id',
                name: 'service-detail',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ServiceDetailPage(serviceId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/info',
            name: 'info',
            builder: (context, state) => const ArticlesPage(),
            routes: [
              GoRoute(
                path: 'article/:slug',
                name: 'article-detail',
                builder: (context, state) {
                  final slug = state.pathParameters['slug']!;
                  return ArticleDetailPage(slug: slug);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
      // Auth sayfaları (Shell dışında)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      // Forum
      GoRoute(
        path: '/forum',
        name: 'forum',
        builder: (context, state) => const ForumPage(),
      ),
      // Acil Durum
      GoRoute(
        path: '/emergency',
        name: 'emergency',
        builder: (context, state) => const EmergencyPage(),
      ),
    ],
  );
});