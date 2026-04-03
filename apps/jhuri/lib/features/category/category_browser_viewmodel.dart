import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../category/data/category_repository.dart';
import '../../providers/database_provider.dart';

/// View model for category browser
class CategoryBrowserViewModel extends BaseViewModel {
  late final CategoryRepository _categoryRepository;

  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  @override
  bool get isLoading => _isLoading;

  @override
  void onSyncSetup() {
    _categoryRepository = ref.read(categoryRepositoryProvider);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _isLoading = true;
    state = ViewStateLoading();

    try {
      final categories = await _categoryRepository.getAll();
      _categories = categories;
      _isLoading = false;
      state = ViewStateSuccess();
    } catch (e) {
      _isLoading = false;
      state = ViewStateError(e.toString());
    }
  }

  @override
  Future<bool> refresh() async {
    try {
      await _loadCategories();
      return true;
    } catch (e) {
      state = ViewStateError(e.toString());
      return false;
    }
  }

  /// Get category by image identifier
  Category? getCategoryByImageIdentifier(String imageIdentifier) {
    try {
      return _categories.firstWhere(
        (cat) => cat.imageIdentifier == imageIdentifier,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if category has items (for custom item count display)
  bool hasItemsInCategory(int categoryId) {
    // This would require item template repository
    // For now, return true for all categories except custom
    return categoryId != 999; // Assuming 999 is for custom items
  }
}

// Provider
final categoryBrowserViewModelProvider =
    NotifierProvider<CategoryBrowserViewModel, ViewState>(
        () => CategoryBrowserViewModel());
