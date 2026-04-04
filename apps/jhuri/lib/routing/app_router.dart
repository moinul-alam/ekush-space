// lib/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/home/home_screen.dart';
import '../features/shopping_list/create_edit_list_screen.dart';
import '../features/category/category_browser_screen.dart';
import '../features/item_template/item_picker_screen.dart';
import '../features/shopping_list/shopping_mode_screen.dart';

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Main app
      GoRoute(
        path: '/',
        redirect: (context, state) {
          // TODO: Check onboardingComplete from SharedPreferences
          // For now, redirect to home (will implement in Phase 4)
          return '/home';
        },
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoryBrowserScreen(),
      ),

      GoRoute(
        path: '/categories/:categoryId/items',
        builder: (context, state) {
          final categoryId = int.parse(state.pathParameters['categoryId']!);
          final categoryName = state.extra as String;
          return ItemPickerScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          );
        },
      ),

      GoRoute(
        path: '/list/new',
        builder: (context, state) => const CreateEditListScreen(listId: null),
      ),

      GoRoute(
        path: '/list/:listId/edit',
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          return CreateEditListScreen(listId: listId);
        },
      ),

      GoRoute(
        path: '/list/:listId',
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          return ShoppingModeScreen(listId: listId);
        },
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});

// Error screen for routing errors
class ErrorScreen extends StatelessWidget {
  final Object? error;

  const ErrorScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error?.toString() ?? 'Unknown error occurred',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
