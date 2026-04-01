import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../core/providers/jhuri_providers.dart';
import '../../../data/repositories/app_settings_repository.dart';
import '../../../data/repositories/item_template_repository.dart';

final settingsViewModelProvider =
    NotifierProvider<SettingsViewModel, ViewState>(() {
  return SettingsViewModel();
});

class SettingsViewModel extends BaseViewModel<void> {
  late final AppSettingsRepository _appSettingsRepository;
  late final ItemTemplateRepository _itemTemplateRepository;

  AppSettingsTableData? _settings;
  List<ItemTemplate> _customItems = [];

  @override
  void onSyncSetup() {
    _appSettingsRepository = ref.read(appSettingsRepositoryProvider);
    _itemTemplateRepository = ref.read(itemTemplateRepositoryProvider);
    _loadSettings();
    _loadCustomItems();
  }

  // Getters
  AppSettingsTableData? get settings => _settings;
  List<ItemTemplate> get customItems => _customItems;

  // Settings management methods
  Future<void> updateThemeMode(String themeMode) async {
    await executeAsync(
      operation: () => _appSettingsRepository.updateThemeMode(themeMode),
      errorMessage: 'থিম মোড আপডেট করতে ব্যর্থ হয়েছে',
    );
  }

  Future<void> updateDefaultUnit(String unit) async {
    await executeAsync(
      operation: () => _appSettingsRepository.updateDefaultUnit(unit),
      errorMessage: 'ডিফল্ট ইউনিট আপডেট করতে ব্যর্থ হয়েছে',
    );
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    await executeAsync(
      operation: () =>
          _appSettingsRepository.updateNotificationsEnabled(enabled),
      errorMessage: 'নোটিফিকেশন আপডেট করতে ব্যর্থ হয়েছে',
    );
  }

  Future<void> updateDefaultReminderTime(String time) async {
    await executeAsync(
      operation: () => _appSettingsRepository.updateDefaultReminderTime(time),
      errorMessage: 'রিমাইন্ডার সময় আপডেট করতে ব্যর্থ হয়েছে',
    );
  }

  Future<void> updateListSortOrder(String sortOrder) async {
    await executeAsync(
      operation: () => _appSettingsRepository.updateListSortOrder(sortOrder),
      errorMessage: 'ফর্দ সাজান আদদেশ করতে ব্যর্থ হয়েছে',
    );
  }

  Future<void> deleteCustomItem(int itemId) async {
    await executeAsync(
      operation: () => _itemTemplateRepository.deleteCustomItem(itemId),
      errorMessage: 'কাস্টম আইটেম মুছে ফেলতে',
      successMessage: 'কাস্টম আইটেম মুছে ফেলতে হয়েছে',
    );

    // Reload custom items
    _loadCustomItems();
  }

  // Data loading methods
  Future<void> _loadSettings() async {
    try {
      _settings = await _appSettingsRepository.getSettings();
    } catch (e) {
      setError('সেটিংস লোড করতে ব্যর্থ হয়েছে: $e');
    }
  }

  void _loadCustomItems() async {
    try {
      _customItems = await _itemTemplateRepository.getCustomItems();
      setSuccess();
    } catch (error) {
      setError('কাস্টম আইটেম লোড করতে ব্যর্থ হয়েছে: $error');
    }
  }

  @override
  Future<bool> refresh() async {
    _loadSettings();
    _loadCustomItems();
    return true;
  }
}
