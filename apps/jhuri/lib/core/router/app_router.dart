import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/jhuri_providers.dart';
import '../../features/home/minimal_home_screen.dart';
import '../../features/category_browser/category_browser_screen.dart';
import '../../features/item_picker/item_picker_screen.dart';
import '../../features/list_create/list_create_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/shopping_mode/shopping_mode_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/widgets/ad_banner_widget.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      final settingsAsync = ref.read(appSettingsProvider);
      return settingsAsync.when(
        data: (settings) {
          final onPath = state.uri.toString();
          if (!settings.onboardingComplete && onPath != '/onboarding') {
            return '/onboarding';
          }
          if (settings.onboardingComplete && onPath == '/onboarding') {
            return '/';
          }
          return null;
        },
        loading: () => null,
        error: (_, __) => null,
      );
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          final String location = state.uri.toString();
          final bool isShoppingMode = location.contains('/shopping/');
          final bool isOnboarding = location == '/onboarding';

          final bool showAd = !isShoppingMode && !isOnboarding;

          return Scaffold(
            body: Column(
              children: [
                Expanded(child: child),
                if (showAd) const AdBannerWidget(),
              ],
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const MinimalHomeScreen(),
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) => const CategoryBrowserScreen(),
            routes: [
              GoRoute(
                path: ':id/items',
                builder: (context, state) {
                  final categoryId = int.parse(state.pathParameters['id']!);
                  final categoryName =
                      state.extra as String? ?? 'আইটেম বাছাই করুন';
                  return ItemPickerScreen(
                    categoryId: categoryId,
                    categoryName: categoryName,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/list/create',
            builder: (context, state) => const ListCreateScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/shopping/:listId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          return ShoppingModeScreen(listId: listId);
        },
      ),
    ],
  );

  ref.listen(appSettingsProvider, (_, __) {
    router.refresh();
  });

  return router;
});
