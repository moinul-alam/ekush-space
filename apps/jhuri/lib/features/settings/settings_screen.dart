// lib/features/settings/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ekush_notifications/ekush_notifications.dart';
import '../../base/jhuri_base_screen.dart';
import '../../providers/settings_providers.dart';
import '../../l10n/jhuri_localizations.dart';

abstract class _SettingsFonts {
  static const double sectionHeader = 13.0;
  static const double tileTitle = 18.0;
  static const double tileSubtitle = 13.0;
  static const double version = 13.0;
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

    // Watch async providers
    final themeModeAsync = ref.watch(themeModeProvider);
    final localeAsync = ref.watch(localeProvider);

    final osGranted = ref.watch(notificationPermissionProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'HindSiliguri',
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
            loading: () => const _SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: 'Loading...',
            ),
            error: (_, __) => const _SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: 'Error',
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
            loading: () => const _SettingsTile(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'Loading...',
            ),
            error: (_, __) => const _SettingsTile(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'Error',
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
              // TODO: Navigate to custom items management screen
              showJhuriSnackBar(message: 'Coming soon');
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
              // TODO: Show about dialog
              showJhuriSnackBar(message: 'Coming soon');
            },
          ),

          _SettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: l10n.privacyPolicy,
            subtitle: l10n.privacyPolicySubtitle,
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final Uri url = Uri.parse('https://ekushlabs.com/privacy');
              try {
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  if (mounted) {
                    showJhuriSnackBar(
                        message: 'লিংক খুলতে সমস্যা হয়েছে',
                        type: SnackBarType.error);
                  }
                }
              } catch (e) {
                if (mounted) {
                  showJhuriSnackBar(
                      message: 'লিংক খুলতে সমস্যা হয়েছে',
                      type: SnackBarType.error);
                }
              }
            },
          ),

          const SizedBox(height: 16),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
    try {
      await ref.read(showPriceTotalNotifierProvider.notifier).setValue(value);
    } catch (e) {
      showJhuriSnackBar(
          message: 'Error updating setting', type: SnackBarType.error);
    }
  }

  Future<void> _toggleNotifications(bool value, WidgetRef ref) async {
    try {
      await ref
          .read(notificationsEnabledNotifierProvider.notifier)
          .setValue(value);
    } catch (e) {
      showJhuriSnackBar(
          message: 'Error updating setting', type: SnackBarType.error);
    }
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
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await openAppSettings();
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
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(selection.first);
                      Navigator.pop(context);
                    }
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text('Error loading theme'),
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
                      final locale = selection.first == 'bn'
                          ? const Locale('bn', 'BD')
                          : const Locale('en', 'US');
                      ref.read(localeProvider.notifier).setLocale(locale);
                      Navigator.pop(context);
                    }
                  },
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => Text('Error loading language'),
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
                  ref
                      .read(currencySymbolNotifierProvider.notifier)
                      .setValue(selection.first);
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
                  ref
                      .read(defaultReminderTimeNotifierProvider.notifier)
                      .setValue(selection.first);
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
                  ref
                      .read(listSortOrderNotifierProvider.notifier)
                      .setValue(selection.first);
                  Navigator.pop(context);
                }
              },
            );
          },
        ),
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_off_rounded,
              color: cs.onErrorContainer, size: 20),
          const SizedBox(width: 12),
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
