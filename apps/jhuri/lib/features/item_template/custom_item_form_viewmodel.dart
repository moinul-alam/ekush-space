import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart' show Value;
import '../item_template/data/item_template_repository.dart';
import '../../providers/database_provider.dart';

/// View model for custom item form
class CustomItemFormViewModel extends BaseViewModel {
  late final ItemTemplateRepository _itemTemplateRepository;

  // Form fields
  String _nameBangla = '';
  String _nameEnglish = '';
  String _selectedCategoryId = '1'; // Default to vegetables
  String _selectedUnit = 'কেজি';
  double _selectedQuantity = 1.0;
  String _selectedIcon = '🥔'; // Default potato icon

  // Getters
  String get nameBangla => _nameBangla;
  String get nameEnglish => _nameEnglish;
  String get selectedCategoryId => _selectedCategoryId;
  String get selectedUnit => _selectedUnit;
  double get selectedQuantity => _selectedQuantity;
  String get selectedIcon => _selectedIcon;

  @override
  void onSyncSetup() {
    _itemTemplateRepository = ref.read(itemTemplateRepositoryProvider);
  }

  /// Update form fields
  void updateNameBangla(String value) {
    _nameBangla = value;
    state = ViewStateSuccess();
  }

  void updateNameEnglish(String value) {
    _nameEnglish = value;
    state = ViewStateSuccess();
  }

  void updateCategoryId(String value) {
    _selectedCategoryId = value;
    state = ViewStateSuccess();
  }

  void updateUnit(String value) {
    _selectedUnit = value;
    state = ViewStateSuccess();
  }

  void updateQuantity(double value) {
    _selectedQuantity = value;
    state = ViewStateSuccess();
  }

  void updateIcon(String value) {
    _selectedIcon = value;
    state = ViewStateSuccess();
  }

  /// Validate form
  bool get isValid => _nameBangla.trim().isNotEmpty;

  /// Save custom item
  Future<int> saveCustomItem({
    String? atLeastOneItemRequired,
  }) async {
    if (!isValid) {
      if (atLeastOneItemRequired != null) {
        state = ViewStateError(atLeastOneItemRequired);
      } else {
        state = ViewStateError('Item name is required');
      }
      return -1;
    }

    state = ViewStateLoading();

    try {
      final customItem = ItemTemplatesCompanion.insert(
        nameBangla: _nameBangla,
        nameEnglish: _nameEnglish,
        categoryId: int.parse(_selectedCategoryId),
        defaultQuantity: _selectedQuantity,
        defaultUnit: _selectedUnit,
        iconIdentifier: Value(_selectedIcon),
        isCustom: Value(true),
        usageCount: Value(0),
        lastUsedAt: DateTime.now(),
        createdAt: Value(DateTime.now()),
      );

      final itemId =
          await _itemTemplateRepository.createFromCompanion(customItem);

      state = ViewStateSuccess();
      return itemId;
    } catch (e) {
      state = ViewStateError(e.toString());
      return -1;
    }
  }

  /// Get available units
  List<String> get availableUnits => [
        'কেজি',
        'গ্রাম',
        'লিটার',
        'মিলিলিটার',
        'পিস',
        'হালি',
        'আঁটি',
        'ডজন',
        'প্যাকেট',
        'বোতল',
        'কৌটা',
        'আঁটি'
      ];

  /// Get available icons (common food emojis)
  List<String> get availableIcons => [
        '🥔',
        '🥕',
        '🧅',
        '🥬',
        '🧄',
        '🥦',
        '🧈',
        '🍅',
        '🍞',
        '🍇',
        '🍓',
        '🍊',
        '🍌',
        '🥒',
        '🍋',
        '🧄',
        '🍆',
        '🥑',
        '🍐',
        '🧊',
        '🥛',
        '🍈',
        '🍉',
        '🫐',
        '🥥',
        '🥦',
        '🧂',
        '🫒',
        '🫐',
        '🥬',
        '🥒',
        '🍄',
        '🍋',
        '🧅',
        '🥚',
        '🍄',
        '🍞',
        '🍇',
        '🍓',
        '🍊',
        '🍌',
        '🥒',
        '🍋',
        '🧄',
        '🍆',
        '🥑',
        '🍐',
        '🧊',
        '🥛',
        '🍈',
        '🍉',
        '🫐',
        '🥥',
        '🥦',
        '🧂',
        '🫒',
        '🫐',
        '🥬',
        '🥒',
        '🍄',
        '🍋',
        '🧅'
      ];
}

// Provider
final customItemFormViewModelProvider =
    NotifierProvider<CustomItemFormViewModel, ViewState>(
        () => CustomItemFormViewModel());
