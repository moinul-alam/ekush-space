import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:go_router/go_router.dart';

import 'package:jhuri/features/home/home_screen.dart';
import 'package:jhuri/features/shopping_list/home_providers.dart';

void main() {
  group('Home Screen Tests', () {
    late ProviderContainer container;
    late List<ShoppingList> mockLists;

    setUp(() {
      mockLists = [
        ShoppingList(
          id: 1,
          title: 'বাজারের ফর্দ',
          buyDate: DateTime.now(),
          createdAt: DateTime.now(),
          isArchived: false,
          isCompleted: false,
          isReminderOn: false,
        ),
        ShoppingList(
          id: 2,
          title: 'সপ্তাহের বাজার',
          buyDate: DateTime.now().add(const Duration(days: 1)),
          createdAt: DateTime.now(),
          isArchived: false,
          isCompleted: false,
          isReminderOn: false,
        ),
      ];

      container = ProviderContainer(
        overrides: [
          homeListsProvider.overrideWith((ref) => HomeListsData(
                todayLists: mockLists
                    .where((l) => l.buyDate.day == DateTime.now().day)
                    .toList(),
                upcomingLists: mockLists
                    .where((l) => l.buyDate.isAfter(DateTime.now()))
                    .toList(),
                pastIncompleteLists: [],
                isLoading: false,
              )),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('Home screen displays lists in 2-column grid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the grid exists
      expect(find.byType(GridView), findsOneWidget);

      // Verify list cards are displayed (using Container since that's what we use)
      expect(find.byType(Container), findsAtLeastNWidgets(2));

      // Verify list titles are displayed
      expect(find.text('বাজারের ফর্দ'), findsOneWidget);
    });

    testWidgets('Home screen shows empty state when no lists',
        (WidgetTester tester) async {
      final emptyContainer = ProviderContainer(
        overrides: [
          homeListsProvider.overrideWith((ref) => const HomeListsData(
                todayLists: [],
                upcomingLists: [],
                pastIncompleteLists: [],
                isLoading: false,
              )),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: emptyContainer,
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const HomeScreen(),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty state message
      expect(find.text('বাজারের কোনো ফর্দ নেই'), findsOneWidget);
      expect(find.text('"+", বাটন চেপে নতুন ফর্দ তৈরি করুন'), findsOneWidget);
    });
  });
}
