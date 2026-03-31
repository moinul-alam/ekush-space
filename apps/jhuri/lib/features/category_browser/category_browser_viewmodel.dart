import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../data/repositories/category_repository.dart';

final categoryBrowserViewModelProvider =
    NotifierProvider<CategoryBrowserViewModel, ViewState>(() {
  return CategoryBrowserViewModel();
});

class CategoryBrowserViewModel extends BaseViewModel<List<Category>> {
  late final CategoryRepository _categoryRepository;

  @override
  void onSyncSetup() {
    _categoryRepository = CategoryRepository(JhuriDatabase());
  }

  @override
  void onInit() {
    _loadCategories();
  }

  void _loadCategories() {
    setLoading();

    _categoryRepository.getAllSorted().then((categories) {
      if (categories.isEmpty) {
        setEmpty(message: 'কোনো ক্যাটাগরি পাওয়া যায়নি');
      } else {
        setSuccess(data: categories);
      }
    }).catchError((error) {
      setError(error.toString());
    });
  }

  List<Category> get categories {
    return successData ?? [];
  }

  @override
  Future<bool> refresh() async {
    _loadCategories();
    return true;
  }
}
