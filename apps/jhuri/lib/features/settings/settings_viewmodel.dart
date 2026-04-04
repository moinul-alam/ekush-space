// lib/features/settings/settings_viewmodel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import '../shopping_list/data/shopping_list_repository.dart';
import '../list_item/data/list_item_repository.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_providers.dart';
import '../../services/shopping_list_notification_service.dart';
import '../../l10n/jhuri_localizations.dart';

class SettingsViewModel extends BaseViewModel {
  late final ShoppingListRepository _shoppingListRepository;
  late final ListItemRepository _listItemRepository;

  @override
  void onSyncSetup() {
    _shoppingListRepository = ref.read(shoppingListRepositoryProvider);
    _listItemRepository = ref.read(listItemRepositoryProvider);
  }

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
  }

  /// Initialize notifications for all active lists
  Future<void> _initializeNotifications() async {
    try {
      final defaultReminderTime = ref.read(defaultReminderTimeProvider);
      await ShoppingListNotificationService.scheduleAllActiveNotifications(
        listRepository: _shoppingListRepository,
        itemRepository: _listItemRepository,
        defaultReminderTime: defaultReminderTime,
      );
    } catch (e) {
      debugPrint('❌ Failed to initialize notifications: $e');
    }
  }

  Future<void> changeTheme(ThemeMode mode, WidgetRef ref) async {
    await executeAsync(
      operation: () async {
        await ref.read(themeModeProvider.notifier).setThemeMode(mode);
      },
      successMessage: null,
      errorMessage: null,
      showLoading: false,
    );
  }

  Future<void> changeLanguage(String languageCode, WidgetRef ref) async {
    await executeAsync(
      operation: () async {
        final locale = languageCode == 'bn'
            ? const Locale('bn', 'BD')
            : const Locale('en', 'US');
        await ref.read(localeProvider.notifier).setLocale(locale);
      },
      successMessage: null,
      errorMessage: null,
      showLoading: false,
    );
  }

  Future<void> toggleShowPriceTotal(bool value, WidgetRef ref) async {
    await executeAsync(
      operation: () async {
        await ref.read(showPriceTotalNotifierProvider.notifier).setValue(value);
      },
      successMessage: null,
      errorMessage: null,
      showLoading: false,
    );
  }

  Future<void> changeDefaultUnit(String unit, WidgetRef ref) async {
    await executeAsync(
      operation: () async {
        await ref.read(defaultUnitNotifierProvider.notifier).setValue(unit);
      },
      successMessage: null,
      errorMessage: null,
      showLoading: false,
    );
  }

  Future<void> changeCurrencySymbol(String symbol, WidgetRef ref) async {
    await executeAsync(
      operation: () async {
        await ref
            .read(currencySymbolNotifierProvider.notifier)
            .setValue(symbol);
      },
      successMessage: null,
      errorMessage: null,
      showLoading: false,
    );
  }

  Future<void> toggleNotifications(bool value, WidgetRef ref) async {
    await executeAsync(
      operation: () async {
        await ref
            .read(notificationsEnabledNotifierProvider.notifier)
            .setValue(value);
      },
      successMessage: null,
      errorMessage: null,
      showLoading: false,
    );
  }

  Future<void> changeDefaultReminderTime(String time, WidgetRef ref) async {
    await executeAsync(
      operation: () async {
        await ref
            .read(defaultReminderTimeNotifierProvider.notifier)
            .setValue(time);

        // Reschedule all notifications with new default time
        await ShoppingListNotificationService.scheduleAllActiveNotifications(
          listRepository: _shoppingListRepository,
          itemRepository: _listItemRepository,
          defaultReminderTime: time,
        );
      },
      successMessage: null,
      errorMessage: null,
      showLoading: false,
    );
  }

  Future<void> changeListSortOrder(String order, WidgetRef ref) async {
    await executeAsync(
      operation: () async {
        await ref.read(listSortOrderNotifierProvider.notifier).setValue(order);
      },
      successMessage: null,
      errorMessage: null,
      showLoading: false,
    );
  }

  Future<void> resetSettings(WidgetRef ref, JhuriLocalizations l10n) async {
    await executeAsync(
      operation: () async {
        // Reset theme to system default
        await ref
            .read(themeModeProvider.notifier)
            .setThemeMode(ThemeMode.system);

        // Reset language to Bangla
        await ref
            .read(localeProvider.notifier)
            .setLocale(const Locale('bn', 'BD'));

        // Reset other settings to defaults
        await ref.read(showPriceTotalNotifierProvider.notifier).setValue(true);
        await ref.read(defaultUnitNotifierProvider.notifier).setValue('কেজি');
        await ref.read(currencySymbolNotifierProvider.notifier).setValue('৳');
        await ref
            .read(notificationsEnabledNotifierProvider.notifier)
            .setValue(true);
        await ref
            .read(defaultReminderTimeNotifierProvider.notifier)
            .setValue('18:00');
        await ref
            .read(listSortOrderNotifierProvider.notifier)
            .setValue('dateDesc');
      },
      loadingMessage: 'রিসেট করা হচ্ছে...',
      successMessage: 'সেটিংস সফলভাবে রিসেট করা হয়েছে',
      errorMessage: 'সেটিংস রিসেট করতে সমস্যা হয়েছে',
    );
  }
}

final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, ViewState>(() => SettingsViewModel());
