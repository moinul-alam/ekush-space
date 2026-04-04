import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_models/ekush_models.dart';
import '../category/data/category_repository.dart';
import '../../providers/database_provider.dart';

/// View model for category browser
class CategoryBrowserViewModel extends AsyncNotifier<List<Category>> {
  late final CategoryRepository _categoryRepository;

  @override
  Future<List<Category>> build() async {
    _categoryRepository = ref.read(categoryRepositoryProvider);
    return _loadCategories();
  }

  Future<List<Category>> _loadCategories() async {
    try {
      return await _categoryRepository.getAll();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  /// Refresh categories
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadCategories());
  }

  /// Get category by image identifier
  Category? getCategoryByImageIdentifier(String imageIdentifier) {
    final categories = state.value;
    if (categories == null) return null;

    try {
      return categories.firstWhere(
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
    AsyncNotifierProvider<CategoryBrowserViewModel, List<Category>>(
        () => CategoryBrowserViewModel());
