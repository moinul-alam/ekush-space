import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:flutter/foundation.dart' hide Category;
import '../../../core/providers/jhuri_providers.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../../data/repositories/list_item_repository.dart';
import '../../../data/repositories/item_template_repository.dart';

final shoppingModeViewModelProvider =
    NotifierProvider<ShoppingModeViewModel, ViewState>(() {
  return ShoppingModeViewModel();
});

class ShoppingModeViewModel extends BaseViewModel<ShoppingModeData> {
  int? _listId;
  late final ShoppingListRepository _shoppingListRepository;
  late final ListItemRepository _listItemRepository;
  late final ItemTemplateRepository _itemTemplateRepository;

  ShoppingList? _list;
  List<ListItem> _items = [];
  List<Category> _categories = [];
  final Map<int, List<ItemTemplate>> _templatesByCategory = {};
  final Map<int, int> _templateToCategory = {};
  bool _completionTriggered = false;

  // Initialize with list ID
  void initialize(int listId) {
    _listId = listId;
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
    _itemTemplateRepository = ref.read(itemTemplateRepositoryProvider);
    _loadListData();
    _loadItems();
    _loadCategoriesAndTemplates();
  }

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
    _itemTemplateRepository = ref.read(itemTemplateRepositoryProvider);
  }

  // Getters
  ShoppingList? get list => _list;
  List<ListItem> get items => _items;
  List<Category> get categories => _categories;
  Map<int, List<ItemTemplate>> get templatesByCategory => _templatesByCategory;
  bool get completionTriggered => _completionTriggered;

  int get boughtCount {
    return _items.where((item) => item.isBought).length;
  }

  int get totalCount {
    return _items.length;
  }

  double? get totalPrice {
    final itemsWithPrice =
        _items.where((item) => item.price != null && item.price! > 0);
    if (itemsWithPrice.isEmpty) return null;

    return itemsWithPrice.fold(
      0.0,
      (sum, item) => (sum ?? 0.0) + ((item.price ?? 0.0) * item.quantity),
    );
  }

  bool get isComplete {
    return boughtCount == totalCount && totalCount > 0;
  }

  String getCategoryName(int categoryId) {
    if (categoryId == 0) return 'অন্যান্য';
    if (categoryId == kFrequentlyUsedCategoryId) return 'সবচেয়ে বেশি ব্যবহৃত';

    final category = _categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(
        id: categoryId,
        nameBangla: 'অজানা বিভাগ',
        nameEnglish: 'Unknown Category',
        imageIdentifier: '',
        iconIdentifier: '',
        sortOrder: 0,
      ),
    );
    return category.nameBangla;
  }

  // Group items by category for UI
  Map<int, List<ListItem>> get itemsByCategory {
    final Map<int, List<ListItem>> grouped = {};

    for (final item in _items) {
      final categoryId = item.templateId != null
          ? _templateToCategory[item.templateId!] ?? 0
          : 0;

      if (!grouped.containsKey(categoryId)) {
        grouped[categoryId] = [];
      }
      grouped[categoryId]!.add(item);
    }

    return grouped;
  }

  // Methods
  Future<void> toggleItem(int itemId, bool current) async {
    final newStatus = !current;

    await executeAsync(
      operation: () async {
        await _listItemRepository.toggleBought(itemId, newStatus);

        // If marked as bought, increment usage in template for smart suggestions
        if (newStatus) {
          final item = _items.firstWhere((i) => i.id == itemId);
          if (item.templateId != null) {
            await _itemTemplateRepository.incrementUsage(item.templateId!);
          }
        }
      },
      errorMessage: 'আইটেম আপডেট করতে ব্যর্থ হয়েছে',
    );
  }

  Future<void> _loadListData() async {
    if (_listId == null) return;

    try {
      _list = await _shoppingListRepository.getListById(_listId!);
    } catch (e) {
      setError('ফর্দ লোড করতে ব্যর্থ হয়েছে: $e');
      return;
    }
  }

  void _loadItems() {
    if (_listId == null) return;

    setLoading();

    _listItemRepository.watchItemsForList(_listId!).listen(
      (items) {
        _items = items;

        // Check if list is complete and trigger completion flow
        if (isComplete && !_completionTriggered) {
          _triggerCompletionFlow();
        }

        setSuccess(
            data: ShoppingModeData(
          list: _list,
          items: items,
          categories: _categories,
          templatesByCategory: _templatesByCategory,
        ));
      },
      onError: (error) {
        setError('আইটেম লোড করতে ব্যর্থ হয়েছে: $error');
      },
    );
  }

  Future<void> _loadCategoriesAndTemplates() async {
    try {
      _categories = await _itemTemplateRepository.getAllCategories();
      _templateToCategory.clear();

      // Load templates for each category
      for (final category in _categories) {
        final templates =
            await _itemTemplateRepository.getByCategory(category.id);
        _templatesByCategory[category.id] = templates;

        // Map each template to its category for grouping
        for (final template in templates) {
          _templateToCategory[template.id] = category.id;
        }
      }

      // Refresh UI once mapping is done
      setSuccess(
          data: ShoppingModeData(
        list: _list,
        items: _items,
        categories: _categories,
        templatesByCategory: _templatesByCategory,
      ));
    } catch (e) {
      // Don't fail the whole view if categories/templates fail to load
      debugPrint('Failed to load categories/templates: $e');
    }
  }

  Future<void> _triggerCompletionFlow() async {
    if (_completionTriggered || _listId == null) return;

    _completionTriggered = true;

    try {
      // Mark list as complete
      await _shoppingListRepository.markListComplete(_listId!);

      // After 3 seconds, archive the list
      Future.delayed(const Duration(seconds: 3), () async {
        await _shoppingListRepository.archiveList(_listId!);
      });
    } catch (e) {
      setError('ফর্দ সম্পর্ণ করতে ব্যর্থ হয়েছে: $e');
    }
  }

  @override
  Future<bool> refresh() async {
    _loadListData();
    _loadItems();
    _loadCategoriesAndTemplates();
    return true;
  }
}

class ShoppingModeData {
  final ShoppingList? list;
  final List<ListItem> items;
  final List<Category> categories;
  final Map<int, List<ItemTemplate>> templatesByCategory;

  const ShoppingModeData({
    required this.list,
    required this.items,
    required this.categories,
    required this.templatesByCategory,
  });
}
