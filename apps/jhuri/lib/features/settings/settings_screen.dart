// lib/features/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_notifications/ekush_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../base/jhuri_base_screen.dart';
import '../../providers/settings_providers.dart';
import '../../l10n/jhuri_localizations.dart';
import '../../shared/widgets/jhuri_app_header.dart';
import 'settings_viewmodel.dart';

abstract class _SettingsFonts {
  static double get sectionHeader => 13.0.sp;
  static double get tileTitle => 18.0.sp;
  static double get tileSubtitle => 13.0.sp;
  static double get version => 13.0.sp;
}

class SettingsScreen extends JhuriBaseScreen {
  const SettingsScreen({super.key});

  @override
  JhuriBaseScreenState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends JhuriBaseScreenState<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(notificationPermissionProvider.notifier).refresh();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    final l10n = JhuriLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModel = ref.read(settingsViewModelProvider.notifier);

    // Watch async providers
    final themeModeAsync = ref.watch(themeModeProvider);
    final localeAsync = ref.watch(localeProvider);

    final osGranted = ref.watch(notificationPermissionProvider).value ?? false;

    return Scaffold(
      appBar: JhuriAppHeader(
        title: l10n.settings,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        children: [
          // ── Display Section ────────────────────────────────────────
          _SectionHeader(title: l10n.appearance),

          // Theme
          themeModeAsync.when(
            data: (currentTheme) => _SettingsTile(
              icon: Icons.palette_outlined,
              title: l10n.theme,
              subtitle: _getThemeName(currentTheme, l10n),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showThemeDialog(context, ref, l10n),
            ),
            loading: () => _SettingsTile(
              icon: Icons.palette_outlined,
              title: l10n.theme,
              subtitle: l10n.loading,
            ),
            error: (_, __) => _SettingsTile(
              icon: Icons.palette_outlined,
              title: l10n.theme,
              subtitle: l10n.error,
            ),
          ),

          // Language
          localeAsync.when(
            data: (currentLocale) => _SettingsTile(
              icon: Icons.language_outlined,
              title: l10n.language,
              subtitle:
                  currentLocale.languageCode == 'bn' ? 'বাংলা' : 'English',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showLanguageDialog(context, ref, l10n),
            ),
            loading: () => _SettingsTile(
              icon: Icons.language_outlined,
              title: l10n.language,
              subtitle: l10n.loading,
            ),
            error: (_, __) => _SettingsTile(
              icon: Icons.language_outlined,
              title: l10n.language,
              subtitle: l10n.error,
            ),
          ),

          const Divider(height: 32),

          // ── Shopping Section ────────────────────────────────────────
          _SectionHeader(title: l10n.shopping),

          // Show price total
          Consumer(
            builder: (context, ref, _) {
              final showPriceTotal = ref.watch(showPriceTotalProvider);
              return _SettingsSwitchTile(
                icon: Icons.calculate_outlined,
                title: l10n.showPriceTotal,
                subtitle: l10n.showPriceTotalSubtitle,
                value: showPriceTotal,
                onChanged: (value) => _toggleShowPriceTotal(value, ref),
              );
            },
          ),

          // Currency symbol
          Consumer(
            builder: (context, ref, _) {
              final currencySymbol = ref.watch(currencySymbolProvider);
              return _SettingsTile(
                icon: Icons.attach_money_outlined,
                title: l10n.currencySymbol,
                subtitle: currencySymbol,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showCurrencyDialog(context, ref, l10n),
              );
            },
          ),

          const Divider(height: 32),

          // ── Notifications Section ───────────────────────────────────
          _SectionHeader(title: l10n.notifications),

          if (!osGranted) _PermissionBanner(l10n: l10n),

          Consumer(
            builder: (context, ref, _) {
              final notificationsEnabled =
                  ref.watch(notificationsEnabledProvider);
              final effectiveValue = notificationsEnabled && osGranted;
              return _SettingsSwitchTile(
                icon: Icons.notifications_outlined,
                title: l10n.enableNotifications,
                subtitle: l10n.enableNotificationsSubtitle,
                value: effectiveValue,
                onChanged: (value) async {
                  if (value && !osGranted) {
                    _showPermissionDialog(context, l10n);
                    return;
                  }
                  await _toggleNotifications(value, ref);
                },
              );
            },
          ),

          Consumer(
            builder: (context, ref, _) {
              final defaultReminderTime =
                  ref.watch(defaultReminderTimeProvider);
              return _SettingsTile(
                icon: Icons.schedule_outlined,
                title: l10n.defaultReminderTime,
                subtitle: defaultReminderTime,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showTimeDialog(context, ref, l10n),
              );
            },
          ),

          const Divider(height: 32),

          // ── Lists Section ───────────────────────────────────────────
          _SectionHeader(title: l10n.lists),

          Consumer(
            builder: (context, ref, _) {
              final listSortOrder = ref.watch(listSortOrderProvider);
              return _SettingsTile(
                icon: Icons.sort_outlined,
                title: l10n.listSortOrder,
                subtitle: listSortOrder == 'dateDesc'
                    ? l10n.newestFirst
                    : l10n.oldestFirst,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showSortOrderDialog(context, ref, l10n),
              );
            },
          ),

          const Divider(height: 32),

          // ── Personal Items Section ──────────────────────────────────
          _SectionHeader(title: l10n.personalItems),

          _SettingsTile(
            icon: Icons.inventory_2_outlined,
            title: l10n.manageCustomItems,
            subtitle: l10n.manageCustomItemsSubtitle,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              GoRouter.of(context).push('/custom-items');
            },
          ),

          const Divider(height: 32),

          // ── About Section ───────────────────────────────────────────
          _SectionHeader(title: l10n.about),

          _SettingsTile(
            icon: Icons.info_outline,
            title: l10n.about,
            subtitle: l10n.appVersion,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showAboutDialog();
            },
          ),

          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.privacyPolicy,
            subtitle: l10n.privacyPolicySubtitle,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => viewModel.launchPrivacyPolicy(l10n),
          ),

          SizedBox(height: 16.h),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Jhuri v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: _SettingsFonts.version,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'HindSiliguri',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getThemeName(ThemeMode mode, JhuriLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.lightMode;
      case ThemeMode.dark:
        return l10n.darkMode;
      case ThemeMode.system:
        return l10n.systemDefault;
    }
  }

  Future<void> _toggleShowPriceTotal(bool value, WidgetRef ref) async {
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    await viewModel.toggleShowPriceTotal(value, ref);
  }

  Future<void> _toggleNotifications(bool value, WidgetRef ref) async {
    final viewModel = ref.read(settingsViewModelProvider.notifier);
    await viewModel.toggleNotifications(value, ref);
  }

  void _showPermissionDialog(BuildContext context, JhuriLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.notificationPermissionTitle),
        content: Text(l10n.notificationPermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.openSettings),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final viewModel = ref.read(settingsViewModelProvider.notifier);
              await viewModel.requestNotificationPermission(l10n);
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(
      BuildContext context, WidgetRef ref, JhuriLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.theme),
        content: Consumer(
          builder: (context, ref, _) {
            final themeModeAsync = ref.watch(themeModeProvider);
            return themeModeAsync.when(
              data: (currentTheme) {
                final themeOptions = <ThemeMode, String>{
                  ThemeMode.light: l10n.lightMode,
                  ThemeMode.dark: l10n.darkMode,
                  ThemeMode.system: l10n.systemDefault,
                };

                return SegmentedButton<ThemeMode>(
                  segments: themeOptions.entries.map((entry) {
                    return ButtonSegment<ThemeMode>(
                      value: entry.key,
                      label: Text(entry.value),
                    );
                  }).toList(),
                  selected: {currentTheme},
                  onSelectionChanged: (Set<ThemeMode> selection) {
                    if (selection.isNotEmpty) {
                      final viewModel =
                          ref.read(settingsViewModelProvider.notifier);
                      viewModel.changeTheme(selection.first, ref);
                      Navigator.pop(context);
                    }
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(l10n.errorLoadingTheme),
            );
          },
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    JhuriLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Consumer(
          builder: (context, ref, _) {
            final localeAsync = ref.watch(localeProvider);
            return localeAsync.when(
              data: (currentLocale) {
                final languageOptions = <String, String>{
                  'bn': 'বাংলা',
                  'en': 'English',
                };

                return SegmentedButton<String>(
                  segments: languageOptions.entries.map((entry) {
                    return ButtonSegment<String>(
                      value: entry.key,
                      label: Text(entry.value),
                    );
                  }).toList(),
                  selected: {currentLocale.languageCode},
                  onSelectionChanged: (Set<String> selection) {
                    if (selection.isNotEmpty) {
                      final viewModel =
                          ref.read(settingsViewModelProvider.notifier);
                      viewModel.changeLanguage(selection.first, ref);
                      Navigator.pop(context);
                    }
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text(l10n.errorLoadingLanguage),
            );
          },
        ),
      ),
    );
  }

  void _showCurrencyDialog(
    BuildContext context,
    WidgetRef ref,
    JhuriLocalizations l10n,
  ) {
    final currencies = ['৳', '\$', '€', '£', '¥', '₹', '₨'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.currencySymbol),
        content: Consumer(
          builder: (context, ref, _) {
            final currentCurrency = ref.watch(currencySymbolProvider);
            return SegmentedButton<String>(
              segments: currencies.map((currency) {
                return ButtonSegment<String>(
                  value: currency,
                  label: Text(currency),
                );
              }).toList(),
              selected: {currentCurrency},
              onSelectionChanged: (Set<String> selection) {
                if (selection.isNotEmpty) {
                  final viewModel =
                      ref.read(settingsViewModelProvider.notifier);
                  viewModel.changeCurrencySymbol(selection.first, ref);
                  Navigator.pop(context);
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _showTimeDialog(
    BuildContext context,
    WidgetRef ref,
    JhuriLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.defaultReminderTime),
        content: Consumer(
          builder: (context, ref, _) {
            final currentTime = ref.watch(defaultReminderTimeProvider);
            return SegmentedButton<String>(
              segments: [
                '06:00',
                '09:00',
                '12:00',
                '15:00',
                '18:00',
                '21:00',
              ].map((time) {
                return ButtonSegment<String>(
                  value: time,
                  label: Text(time),
                );
              }).toList(),
              selected: {currentTime},
              onSelectionChanged: (Set<String> selection) {
                if (selection.isNotEmpty) {
                  final viewModel =
                      ref.read(settingsViewModelProvider.notifier);
                  viewModel.changeDefaultReminderTime(selection.first, ref);
                  Navigator.pop(context);
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _showSortOrderDialog(
    BuildContext context,
    WidgetRef ref,
    JhuriLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.listSortOrder),
        content: Consumer(
          builder: (context, ref, _) {
            final currentOrder = ref.watch(listSortOrderProvider);
            return SegmentedButton<String>(
              segments: [
                ButtonSegment<String>(
                  value: 'dateDesc',
                  label: Text(l10n.newestFirst),
                ),
                ButtonSegment<String>(
                  value: 'dateAsc',
                  label: Text(l10n.oldestFirst),
                ),
              ],
              selected: {currentOrder},
              onSelectionChanged: (Set<String> selection) {
                if (selection.isNotEmpty) {
                  final viewModel =
                      ref.read(settingsViewModelProvider.notifier);
                  viewModel.changeListSortOrder(selection.first, ref);
                  Navigator.pop(context);
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _showAboutDialog() {
    final l10n = JhuriLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.about),
        content: FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final version = snapshot.data?.version ?? '1.0.0';
            final buildNumber = snapshot.data?.buildNumber ?? '1';
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.appDescription),
                SizedBox(height: 8.h),
                Text('${l10n.appVersion}: $version ($buildNumber)'),
                SizedBox(height: 8.h),
                Text(l10n.developedBy),
                SizedBox(height: 8.h),
                Text(l10n.allRightsReserved),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(JhuriLocalizations.of(context).ok),
          ),
        ],
      ),
    );
  }
}

class _PermissionBanner extends StatelessWidget {
  final JhuriLocalizations l10n;
  const _PermissionBanner({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_off_rounded,
              color: cs.onErrorContainer, size: 20),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              l10n.notificationPermissionDeniedBanner,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: _SettingsFonts.tileSubtitle,
                    color: cs.onErrorContainer,
                    fontFamily: 'HindSiliguri',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          fontSize: _SettingsFonts.sectionHeader,
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          fontFamily: 'HindSiliguri',
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: _SettingsFonts.tileTitle,
          fontWeight: FontWeight.w500,
          fontFamily: 'HindSiliguri',
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: _SettingsFonts.tileSubtitle,
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'HindSiliguri',
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SwitchListTile(
      secondary: Icon(icon, color: colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: _SettingsFonts.tileTitle,
          fontWeight: FontWeight.w500,
          fontFamily: 'HindSiliguri',
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: _SettingsFonts.tileSubtitle,
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'HindSiliguri',
              ),
            )
          : null,
      value: value,
      onChanged: onChanged,
    );
  }
}
