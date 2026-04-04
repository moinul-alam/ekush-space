import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:drift/drift.dart' show Value;
import '../../providers/database_provider.dart';
import '../../providers/item_selection_provider.dart';
import '../../providers/settings_providers.dart';
import '../shopping_list/data/shopping_list_repository.dart';
import '../list_item/data/list_item_repository.dart';
import '../../services/shopping_list_notification_service.dart';

/// View model for creating and editing shopping lists
class CreateEditListViewModel extends BaseViewModel {
  late final ShoppingListRepository _shoppingListRepository;
  late final ListItemRepository _listItemRepository;

  // Form fields
  String _title = '';
  DateTime _buyDate = DateTime.now();
  bool _isReminderOn = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0);
  List<ListItem> _items = [];

  // Edit mode
  int? _editingListId;
  bool get isEditMode => _editingListId != null;

  // Getters
  String get title => _title;
  DateTime get buyDate => _buyDate;
  bool get isReminderOn => _isReminderOn;
  TimeOfDay get reminderTime => _reminderTime;
  List<ListItem> get items => _items;
  int get itemCount => _items.length;
  double get totalPrice => _items.fold(
      0.0, (sum, item) => sum + (item.price ?? 0.0) * item.quantity);

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
  }

  /// Initialize for creating a new list
  void initializeForCreate() {
    _title = '';
    _buyDate = DateTime.now();
    _isReminderOn = false;
    _reminderTime = const TimeOfDay(hour: 18, minute: 0);

    // Load items from temporary selection state
    final itemSelection = ref.read(itemSelectionProvider);
    _items = List.from(itemSelection.selectedItems);

    _editingListId = null;
    state = ViewStateSuccess();
  }

  /// Initialize for editing an existing list
  Future<void> initializeForEdit(int listId) async {
    state = ViewStateLoading();

    try {
      final list = await _shoppingListRepository.getById(listId);
      if (list == null) {
        state = ViewStateError('List not found');
        return;
      }

      final items = await _listItemRepository.getByListId(listId);

      _title = list.title;
      _buyDate = list.buyDate;
      _isReminderOn = list.isReminderOn;
      _reminderTime =
          TimeOfDay.fromDateTime(list.reminderTime ?? DateTime.now());
      _items = items;
      _editingListId = listId;

      state = ViewStateSuccess();
    } catch (e) {
      state = ViewStateError(e.toString());
    }
  }

  /// Update form fields
  void updateTitle(String value) {
    _title = value;
    state = ViewStateSuccess();
  }

  void updateBuyDate(DateTime value) {
    _buyDate = value;
    state = ViewStateSuccess();
  }

  void updateReminder(bool value) {
    _isReminderOn = value;
    state = ViewStateSuccess();
  }

  void updateReminderTime(TimeOfDay value) {
    _reminderTime = value;
    state = ViewStateSuccess();
  }

  /// Add item to list
  void addItem(ListItem item) {
    _items.add(item);
    state = ViewStateSuccess();
  }

  /// Remove item from list
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      state = ViewStateSuccess();
    }
  }

  /// Update item quantity and unit
  void updateItem(int index, {double? quantity, String? unit, double? price}) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      _items[index] = item.copyWith(
        quantity: quantity ?? item.quantity,
        unit: unit ?? item.unit,
        price: Value(price ?? item.price),
      );
      state = ViewStateSuccess();
    }
  }

  /// Save list (create or update)
  Future<int> saveList() async {
    if (_items.isEmpty) {
      state = ViewStateError('অন্তত একটি আইটেম যোগ করুন');
      return -1;
    }

    state = ViewStateLoading();

    try {
      int listId;

      if (isEditMode) {
        // Update existing list
        final updatedList = ShoppingListsCompanion.insert(
          title: _title.isEmpty ? Value.absent() : Value(_title),
          buyDate: _buyDate,
          reminderTime: Value(
              _isReminderOn ? _combineDateTime(_buyDate, _reminderTime) : null),
          isReminderOn: Value(_isReminderOn),
          createdAt: DateTime.now(), // Will be updated by database
          completedAt: const Value(null),
          sourceListId: const Value(null),
        );

        await _shoppingListRepository.createFromCompanion(updatedList);
        listId = _editingListId!;

        // Delete existing items and add new ones
        await _listItemRepository.deleteByListId(listId);
      } else {
        // Create new list
        final newList = ShoppingListsCompanion.insert(
          title: _title.isEmpty ? const Value.absent() : Value(_title),
          buyDate: _buyDate,
          reminderTime: Value(
              _isReminderOn ? _combineDateTime(_buyDate, _reminderTime) : null),
          isReminderOn: Value(_isReminderOn),
          createdAt: DateTime.now(),
        );

        listId = await _shoppingListRepository.createFromCompanion(newList);
      }

      // Add items with proper sort order
      for (int i = 0; i < _items.length; i++) {
        final item = _items[i];
        final newItem = ListItemsCompanion.insert(
          listId: listId,
          templateId: item.templateId == null
              ? const Value(null)
              : Value(item.templateId),
          nameBangla: item.nameBangla,
          nameEnglish: item.nameEnglish,
          quantity: Value(item.quantity),
          unit: item.unit,
          price: item.price == null ? const Value(null) : Value(item.price),
          isBought: const Value(false),
          sortOrder: i,
          addedAt: DateTime.now(),
        );
        await _listItemRepository.createFromCompanion(newItem);
      }

      // Clear temporary selection state if this was a new list
      if (!isEditMode) {
        ref.read(itemSelectionProvider.notifier).clearSelections();
      }

      // Schedule notification if reminder is enabled
      if (_isReminderOn) {
        final reminderTimeString =
            '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}';
        await ShoppingListNotificationService.scheduleNotification(
          listId: listId,
          buyDate: _buyDate,
          reminderTime: reminderTimeString,
          listRepository: _shoppingListRepository,
          itemRepository: _listItemRepository,
        );
      }

      state = ViewStateSuccess();
      return listId;
    } catch (e) {
      state = ViewStateError(e.toString());
      return -1;
    }
  }

  /// Refresh items from temporary selection state (for new lists)
  void refreshFromSelectionState() {
    final itemSelection = ref.read(itemSelectionProvider);
    _items = List.from(itemSelection.selectedItems);
    state = ViewStateSuccess();
  }

  /// Validate form
  bool get isValid => _items.isNotEmpty;

  /// Check if title is empty
  bool get isTitleEmpty => _title.trim().isEmpty;

  /// Combine date and time
  DateTime _combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  /// Format time for display
  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format date for display
  String formatDateForDisplay(DateTime date) {
    final days = [
      'রবিবার',
      'সোমবার',
      'মঙ্গলবার',
      'বুধবার',
      'বৃহস্পতিবার',
      'শুক্রবার',
      'শনিবার'
    ];
    final months = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];

    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
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
        'কৌটা'
      ];
}

// Provider
final createEditListViewModelProvider =
    NotifierProvider<CreateEditListViewModel, ViewState>(
        () => CreateEditListViewModel());
