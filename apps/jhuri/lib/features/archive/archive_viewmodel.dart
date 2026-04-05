// lib/features/archive/archive_viewmodel.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../providers/database_provider.dart';
import '../shopping_list/data/shopping_list_repository.dart';

class ArchiveViewModel extends BaseViewModel<List<ShoppingList>> {
  late final ShoppingListRepository _repository;

  List<ShoppingList> get archivedLists => successData ?? [];
  bool get hasData => archivedLists.isNotEmpty;

  @override
  void onSyncSetup() {
    _repository = ref.read(shoppingListRepositoryProvider);
  }

  @override
  void onInit() {
    super.onInit();
    _loadArchivedLists();
  }

  Future<void> _loadArchivedLists() async {
    await executeAsync(
      operation: () async {
        final lists = await _repository.getArchived();
        setSuccess(data: lists);
        return lists;
      },
      loadingMessage: 'আর্কাইভ লোড হচ্ছে...',
    );
  }

  @override
  Future<bool> refresh() async {
    await _loadArchivedLists();
    return !hasError;
  }
}

final archiveViewModelProvider =
    NotifierProvider<ArchiveViewModel, ViewState>(() => ArchiveViewModel());
