// lib/features/archive/archive_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../providers/database_provider.dart';

// Provider for archived lists - sourced from the same repository as home providers
final archivedListsProvider = FutureProvider<List<ShoppingList>>((ref) async {
  final repo = ref.watch(shoppingListRepositoryProvider);
  return await repo.getArchived();
});
