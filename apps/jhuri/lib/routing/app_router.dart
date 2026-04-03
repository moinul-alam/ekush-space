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
import '../config/jhuri_constants.dart';

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash/Onboarding flow
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main app
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),

      // Create/Edit List
      GoRoute(
        path: '/list/create',
        builder: (context, state) => const CreateEditListScreen(),
      ),
      GoRoute(
        path: '/list/edit/:listId',
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          return CreateEditListScreen(listId: listId);
        },
      ),

      // Category Browser
      GoRoute(
        path: '/list/:listId/categories',
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          return CategoryBrowserScreen(listId: listId);
        },
      ),

      // Item Picker
      GoRoute(
        path: '/list/:listId/category/:categoryId/items',
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          final categoryId = int.parse(state.pathParameters['categoryId']!);
          return ItemPickerScreen(listId: listId, categoryId: categoryId);
        },
      ),

      // Shopping Mode
      GoRoute(
        path: '/list/:listId/shop',
        builder: (context, state) {
          final listId = int.parse(state.pathParameters['listId']!);
          return ShoppingModeScreen(listId: listId);
        },
      ),
    ],

    // Redirect logic based on onboarding status
    redirect: (context, state) {
      // For Phase 2, we'll implement basic onboarding check
      // In Phase 3+, this will check SharedPreferences
      return null; // No redirect for now
    },

    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
});

// Splash screen - will determine if onboarding is needed
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For Phase 2, we'll show a simple splash and navigate to onboarding
    // In Phase 3+, this will check SharedPreferences and navigate accordingly

    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        context.go('/onboarding');
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF2D6A4F), // Jhuri primary color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_basket_outlined,
                size: 60,
                color: Color(0xFF2D6A4F),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              JhuriConstants.appName,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'HindSiliguri',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'বাজারের ফর্দ, হাতের মুঠোয়',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontFamily: 'NotoSansBengali',
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

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
