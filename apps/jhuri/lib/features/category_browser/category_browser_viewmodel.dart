import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../core/providers/jhuri_providers.dart';
import '../../data/repositories/category_repository.dart';

final categoryBrowserViewModelProvider =
    NotifierProvider<CategoryBrowserViewModel, ViewState>(() {
  return CategoryBrowserViewModel();
});

class CategoryBrowserViewModel extends BaseViewModel<List<Category>> {
  final Map<int, List<int>> _selectedItemsByCategory = {};
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];

  @override
  void onSyncSetup() {
    // Repository is accessed through providers, no need to store instance
  }

  @override
  void onInit() {
    _loadCategories();
  }

  void _loadCategories() {
    setLoading();

    // Use the categories provider instead of direct repository access
    ref.read(categoriesProvider.future).then((categories) {
      _allCategories = categories;
      _filteredCategories = categories;

      if (categories.isEmpty) {
        setEmpty(message: 'কোনো ক্যাটাগরি পাওয়া যায়নি');
      } else {
        setSuccess(data: _filteredCategories);
      }
    }).catchError((error) {
      setError(error.toString());
    });
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      _filteredCategories = _allCategories;
    } else {
      _filteredCategories = _allCategories
          .where((cat) =>
              cat.nameBangla.toLowerCase().contains(query.toLowerCase()) ||
              cat.nameEnglish.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setSuccess(data: _filteredCategories);
  }

  List<Category> get categories {
    return _filteredCategories;
  }

  // Item selection management
  void toggleItemSelection(int categoryId, int itemId) {
    if (!_selectedItemsByCategory.containsKey(categoryId)) {
      _selectedItemsByCategory[categoryId] = [];
    }

    final items = _selectedItemsByCategory[categoryId]!;
    if (items.contains(itemId)) {
      items.remove(itemId);
    } else {
      items.add(itemId);
    }

    if (items.isEmpty) {
      _selectedItemsByCategory.remove(categoryId);
    }
  }

  bool isItemSelected(int categoryId, int itemId) {
    return _selectedItemsByCategory[categoryId]?.contains(itemId) ?? false;
  }

  List<int> getSelectedItemsForCategory(int categoryId) {
    return _selectedItemsByCategory[categoryId] ?? [];
  }

  int get totalSelectedItemCount {
    return _selectedItemsByCategory.values
        .fold(0, (sum, items) => sum + items.length);
  }

  void clearAllSelections() {
    _selectedItemsByCategory.clear();
  }

  Future<int> addCategory(String nameBangla) async {
    final repository = CategoryRepository(ref.read(databaseProvider));
    final count = await repository.countAll();

    final id = await repository.insert(CategoriesCompanion.insert(
      nameBangla: nameBangla,
      nameEnglish: nameBangla, // Fallback to Bangla for English name
      imageIdentifier: 'custom',
      iconIdentifier: 'category',
      sortOrder: Value(count + 1),
    ));

    // Refresh categories
    _loadCategories();

    return id;
  }

  @override
  Future<bool> refresh() async {
    _loadCategories();
    return true;
  }
}
