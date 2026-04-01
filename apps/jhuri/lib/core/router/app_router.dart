import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/shopping_mode/shopping_mode_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/list_create/list_create_screen.dart';
import '../../features/category_browser/category_browser_screen.dart';
import '../../features/item_picker/item_picker_screen.dart';
import '../../shared/widgets/jhuri_drawer.dart';
import '../../features/home/widgets/ad_banner_widget.dart';
import '../providers/jhuri_providers.dart';

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
          final bool isPopUpScreen = location == '/list/create' || 
                                   location.contains('/shopping/');
          final bool isOnboarding = location == '/onboarding';
          
          final bool showAd = !isPopUpScreen && !isOnboarding;

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
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/categories',
            parentNavigatorKey: rootNavigatorKey,
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
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/list/create',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ListCreateScreen(),
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
