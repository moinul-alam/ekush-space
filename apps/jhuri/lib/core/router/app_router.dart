import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/home_screen.dart';
import '../../features/list_create/list_create_screen.dart';
import '../../features/category_browser/category_browser_screen.dart';
import '../../features/item_picker/item_picker_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../providers/jhuri_providers.dart';

// Placeholder screens for screens not yet built

class ShoppingModeScreen extends StatelessWidget {
  const ShoppingModeScreen({super.key, required this.listId});

  final String listId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Text('Shopping Mode Screen - List ID: $listId\nTo be implemented'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Settings Screen - To be implemented'),
      ),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
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
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/list/create',
        builder: (context, state) => const ListCreateScreen(),
      ),
      GoRoute(
        path: '/list/:id/shopping',
        builder: (context, state) {
          final listId = state.pathParameters['id']!;
          return ShoppingModeScreen(listId: listId);
        },
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoryBrowserScreen(),
      ),
      GoRoute(
        path: '/categories/:id/items',
        builder: (context, state) {
          final categoryId = int.parse(state.pathParameters['id']!);
          return ItemPickerScreen(
            categoryId: categoryId,
            categoryName: 'Category $categoryId', // Placeholder name
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );

  ref.listen(appSettingsProvider, (_, __) {
    router.refresh();
  });

  return router;
});
