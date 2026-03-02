import 'package:flutter/material.dart';
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

// Custom fade transition
CustomTransitionPage<void> _buildFadeTransition({
  required Widget child,
  required GoRouterState state,
  Duration duration = const Duration(milliseconds: 300),
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

// Custom slide-up transition
CustomTransitionPage<void> _buildSlideUpTransition({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}

// Custom scale transition
CustomTransitionPage<void> _buildScaleTransition({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.9, end: 1.0).animate(curved),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // Onboarding - fade
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) => _buildFadeTransition(
          child: const OnboardingPage(),
          state: state,
          duration: const Duration(milliseconds: 500),
        ),
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
            pageBuilder: (context, state) => _buildFadeTransition(
              child: const HomePage(),
              state: state,
            ),
          ),
          GoRoute(
            path: '/map',
            name: 'map',
            pageBuilder: (context, state) => _buildFadeTransition(
              child: const MapPage(),
              state: state,
            ),
            routes: [
              GoRoute(
                path: 'service/:id',
                name: 'service-detail',
                pageBuilder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return _buildSlideUpTransition(
                    child: ServiceDetailPage(serviceId: id),
                    state: state,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/info',
            name: 'info',
            pageBuilder: (context, state) => _buildFadeTransition(
              child: const ArticlesPage(),
              state: state,
            ),
            routes: [
              GoRoute(
                path: 'article/:slug',
                name: 'article-detail',
                pageBuilder: (context, state) {
                  final slug = state.pathParameters['slug']!;
                  return _buildSlideUpTransition(
                    child: ArticleDetailPage(slug: slug),
                    state: state,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => _buildFadeTransition(
              child: const ProfilePage(),
              state: state,
            ),
          ),
        ],
      ),
      // Auth sayfaları - Scale
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _buildScaleTransition(
          child: const LoginPage(),
          state: state,
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => _buildSlideUpTransition(
          child: const RegisterPage(),
          state: state,
        ),
      ),
      // Forum - Slide up
      GoRoute(
        path: '/forum',
        name: 'forum',
        pageBuilder: (context, state) => _buildSlideUpTransition(
          child: const ForumPage(),
          state: state,
        ),
      ),
      // Acil Durum - Scale (acil vurgu)
      GoRoute(
        path: '/emergency',
        name: 'emergency',
        pageBuilder: (context, state) => _buildScaleTransition(
          child: const EmergencyPage(),
          state: state,
        ),
      ),
    ],
  );
});