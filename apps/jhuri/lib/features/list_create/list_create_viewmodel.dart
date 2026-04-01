import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import 'package:ekush_notifications/ekush_notifications.dart';
import 'package:ekush_ads/ekush_ads.dart';
import 'package:drift/drift.dart';
import '../../../core/utils/bangla_date_formatter.dart';
import '../../../core/providers/jhuri_providers.dart';
import '../../../data/repositories/shopping_list_repository.dart';
import '../../../data/repositories/list_item_repository.dart';
import '../item_picker/item_picker_viewmodel.dart';

final createListViewModelProvider =
    NotifierProvider<CreateListViewModel, ViewState>(() {
  return CreateListViewModel();
});

class CreateListViewModel extends BaseViewModel<void> {
  late final ShoppingListRepository _shoppingListRepository;
  late final ListItemRepository _listItemRepository;
  late final AdService _adService;

  // Form fields
  String _title = '';
  DateTime _buyDate = DateTime.now();
  bool _isReminderOn = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 18, minute: 0);

  // Items management
  final List<SelectedItem> _items = [];

  // Edit mode
  ShoppingList? _editingList;
  ShoppingList? _duplicateFrom;

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
    _adService = ref.read(adServiceProvider);
  }

  // Getters
  String get title => _title;
  DateTime get buyDate => _buyDate;
  bool get isReminderOn => _isReminderOn;
  TimeOfDay get reminderTime => _reminderTime;
  ShoppingList? get editingList => _editingList;
  bool get isEditMode => _editingList != null;
  bool get isDuplicateMode => _duplicateFrom != null;
  List<SelectedItem> get items => List.unmodifiable(_items);

  double get totalPrice {
    return _items.fold(
        0.0, (sum, item) => sum + (item.price ?? 0.0) * item.quantity);
  }

  bool get hasAnyItemWithPrice {
    return _items.any((item) => item.price != null && item.price! > 0);
  }

  // Setters
  void setTitle(String value) {
    _title = value;
  }

  void setBuyDate(DateTime value) {
    _buyDate = value;
  }

  void setReminderOn(bool value) {
    _isReminderOn = value;
  }

  void setReminderTime(TimeOfDay value) {
    _reminderTime = value;
  }

  void initializeForEdit(ShoppingList list) {
    _editingList = list;
    _title = list.title;
    _buyDate = list.buyDate;
    _isReminderOn = list.isReminderOn;
    if (list.reminderTime != null) {
      _reminderTime = TimeOfDay(
        hour: list.reminderTime!.hour,
        minute: list.reminderTime!.minute,
      );
    }

    // Load existing items for edit mode
    _loadExistingItems(list.id);
  }

  void initializeForDuplicate(ShoppingList list) {
    _duplicateFrom = list;
    _title = '${list.title} (কপি)';
    _buyDate = DateTime.now();
    _isReminderOn = list.isReminderOn;
    if (list.reminderTime != null) {
      _reminderTime = TimeOfDay(
        hour: list.reminderTime!.hour,
        minute: list.reminderTime!.minute,
      );
    }

    // Load existing items for duplicate mode
    _loadExistingItems(list.id);
  }

  Future<void> _loadExistingItems(int listId) async {
    try {
      final listItems = await _listItemRepository.getItemsForList(listId);
      _items.clear();

      for (final listItem in listItems) {
        _items.add(SelectedItem(
          templateId: listItem.templateId ?? 0,
          nameBangla: listItem.nameBangla,
          quantity: listItem.quantity,
          unit: listItem.unit,
          price: listItem.price,
        ));
      }

      notifyListeners();
    } catch (e) {
      setError('আইটেম লোড করতে ব্যর্থ হয়েছে: $e');
    }
  }

  // Item management methods
  void addItem(
      ItemTemplate template, double quantity, String unit, double? price) {
    // Remove existing item with same templateId if it exists
    _items.removeWhere((item) => item.templateId == template.id);

    // Add the new item
    _items.add(SelectedItem(
      templateId: template.id,
      nameBangla: template.nameBangla,
      quantity: quantity,
      unit: unit,
      price: price,
    ));

    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateItem(int index, double quantity, String unit, double? price) {
    if (index >= 0 && index < _items.length) {
      final item = _items[index];
      _items[index] = SelectedItem(
        templateId: item.templateId,
        nameBangla: item.nameBangla,
        quantity: quantity,
        unit: unit,
        price: price,
      );
      notifyListeners();
    }
  }

  void clearItems() {
    _items.clear();
    notifyListeners();
  }

  // Import items from ItemPickerViewModel
  void importItemsFromPicker(List<SelectedItem> selectedItems) {
    _items.clear();
    _items.addAll(selectedItems);
    notifyListeners();
  }

  Future<bool> save() async {
    // Validate at least one item
    if (_items.isEmpty) {
      setError('অন্তত একটি আইটেম যোগ করুন');
      return false;
    }

    return await executeAsync(
      operation: () async {
        int listId;

        if (isEditMode) {
          // Update existing list
          await _shoppingListRepository.updateList(
            ShoppingListsCompanion(
              id: Value(_editingList!.id),
              title: Value(_title.trim().isEmpty ? 'ফর্দ' : _title.trim()),
              buyDate: Value(_buyDate),
              isReminderOn: Value(_isReminderOn),
              reminderTime: Value(_isReminderOn
                  ? DateTime(
                      _buyDate.year,
                      _buyDate.month,
                      _buyDate.day,
                      _reminderTime.hour,
                      _reminderTime.minute,
                    )
                  : null),
            ),
          );

          // Delete existing list items
          await _listItemRepository.deleteItemsForList(_editingList!.id);
          listId = _editingList!.id;
        } else {
          // Create new list
          listId = await _shoppingListRepository.createList(
            buyDate: _buyDate,
            title: _title.trim().isEmpty ? 'ফর্দ' : _title.trim(),
            reminderTime: _isReminderOn
                ? DateTime(
                    _buyDate.year,
                    _buyDate.month,
                    _buyDate.day,
                    _reminderTime.hour,
                    _reminderTime.minute,
                  )
                : null,
            isReminderOn: _isReminderOn,
          );
        }

        // Insert all list items
        for (int i = 0; i < _items.length; i++) {
          final item = _items[i];
          await _listItemRepository.addItem(
            listId: listId,
            templateId: item.templateId == 0 ? null : item.templateId,
            nameBangla: item.nameBangla,
            quantity: item.quantity,
            unit: item.unit,
            price: item.price,
            sortOrder: i,
          );
        }

        // Schedule reminder if enabled
        if (_isReminderOn) {
          await scheduleReminder(listId);
        }

        // Show real interstitial ad
        _adService.showInterstitialIfAvailable();

        return true;
      },
      successMessage:
          isEditMode ? 'ফর্দ আপডেট হয়েছে' : 'নতুন ফর্দ তৈরি হয়েছে',
      errorMessage: 'ফর্দ সংরক্ষণ করতে ব্যর্থ হয়েছে',
      showLoading: true,
    );
  }

  Future<void> scheduleReminder(int listId) async {
    try {
      final reminderDateTime = DateTime(
        _buyDate.year,
        _buyDate.month,
        _buyDate.day,
        _reminderTime.hour,
        _reminderTime.minute,
      );

      // Only schedule if reminder time is in the future
      if (reminderDateTime.isAfter(DateTime.now())) {
        const androidDetails = AndroidNotificationDetails(
          'jhuri_reminders',
          'ঝুড়ি রিমাইন্ডার',
          channelDescription: 'কেনাকাটার তালিকার রিমাইন্ডার',
          importance: Importance.high,
          priority: Priority.high,
        );
        const iosDetails = DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
        const details = NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );

        await LocalNotificationService.scheduleZoned(
          id: listId,
          scheduledTime: reminderDateTime,
          title: 'কেনাকাটার রিমাইন্ডার',
          body:
              '${_title.trim().isEmpty ? 'ফর্দ' : _title.trim()} - কেনার দিন: ${BanglaDateFormatter.formatDate(_buyDate)}',
          details: details,
        );
      }
    } catch (e) {
      debugPrint('Failed to schedule reminder: $e');
    }
  }

  void reset() {
    _title = '';
    _buyDate = DateTime.now();
    _isReminderOn = false;
    _reminderTime = const TimeOfDay(hour: 18, minute: 0);
    _editingList = null;
    _duplicateFrom = null;
    _items.clear();
    resetState();
  }

  void notifyListeners() {
    // Riverpod NotifierProvider will automatically rebuild when state changes
    // No need for manual listener notification
  }
}
