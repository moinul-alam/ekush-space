import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ekush_core/ekush_core.dart';
import 'package:ekush_models/ekush_models.dart';
import '../../../config/jhuri_constants.dart';
import '../../shared/widgets/jhuri_app_bar.dart';
import '../../shared/widgets/jhuri_drawer.dart';
import 'settings_viewmodel.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final viewState = ref.watch(settingsViewModelProvider);
    final viewModel = ref.watch(settingsViewModelProvider.notifier);

    if (viewState is ViewStateError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64),
              const SizedBox(height: 16),
              Text(
                viewState.message,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => viewModel.refresh(),
                child: const Text('আবার চেষ্টা করুন'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewState is ViewStateLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'লোড হচ্ছে...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final settings = viewModel.settings;
    final customItems = viewModel.customItems;

    return Scaffold(
      appBar: const JhuriAppBar(
        title: 'সেটিংস',
      ),
      drawer: const JhuriDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Display Section
          buildDisplaySection(context, settings),
          const SizedBox(height: 24),

          // Shopping Section
          buildShoppingSection(context, settings),
          const SizedBox(height: 24),

          // Personal Items Section
          buildPersonalItemsSection(context, customItems, viewModel),
          const SizedBox(height: 24),

          // About Section
          buildAboutSection(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget buildDisplaySection(
      BuildContext context, AppSettingsTableData? settings) {
    return buildSection(
      title: 'ডিসপ্লে',
      children: [
        buildThemeModeSelector(context, settings),
        const SizedBox(height: 16),
        buildDefaultUnitSelector(context, settings),
      ],
    );
  }

  Widget buildThemeModeSelector(
      BuildContext context, AppSettingsTableData? settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'থিম মোড',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'system', label: Text('সিস্টেম')),
            ButtonSegment(value: 'light', label: Text('হালকা')),
            ButtonSegment(value: 'dark', label: Text('গাঢ়')),
          ],
          selected: {settings?.themeMode ?? 'system'},
          onSelectionChanged: (Set<String> newSelection) {
            ref
                .read(settingsViewModelProvider.notifier)
                .updateThemeMode(newSelection.first);
          },
        ),
      ],
    );
  }

  Widget buildDefaultUnitSelector(
      BuildContext context, AppSettingsTableData? settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ডিফল্ট ইউনিট',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: JhuriConstants.availableUnits
              .map((unit) => ButtonSegment(value: unit, label: Text(unit)))
              .toList(),
          selected: {settings?.defaultUnit ?? 'কেজি'},
          onSelectionChanged: (Set<String> newSelection) {
            ref
                .read(settingsViewModelProvider.notifier)
                .updateDefaultUnit(newSelection.first);
          },
        ),
      ],
    );
  }

  Widget buildShoppingSection(
      BuildContext context, AppSettingsTableData? settings) {
    return buildSection(
      title: 'কেনাকাটি',
      children: [
        buildNotificationsSwitch(context, settings),
        const SizedBox(height: 16),
        buildReminderTimeSelector(context, settings),
        const SizedBox(height: 16),
        buildListSortOrderSelector(context, settings),
      ],
    );
  }

  Widget buildNotificationsSwitch(
      BuildContext context, AppSettingsTableData? settings) {
    return SwitchListTile(
      title: const Text('নোটিফিকেশন'),
      subtitle: const Text('কেনার দিনে রিমাইন্ডার নোটিফিকেশন'),
      value: settings?.notificationsEnabled ?? true,
      onChanged: (value) {
        ref
            .read(settingsViewModelProvider.notifier)
            .updateNotificationsEnabled(value);
      },
    );
  }

  Widget buildReminderTimeSelector(
      BuildContext context, AppSettingsTableData? settings) {
    return ListTile(
      title: const Text('ডিফল্ট রিমাইন্ডার সময়'),
      subtitle: Text(settings?.defaultReminderTime ?? '18:00'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour:
                int.parse(settings?.defaultReminderTime.split(':')[0] ?? '18'),
            minute:
                int.parse(settings?.defaultReminderTime.split(':')[1] ?? '00'),
          ),
        );

        if (time != null) {
          final formattedTime =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          ref
              .read(settingsViewModelProvider.notifier)
              .updateDefaultReminderTime(formattedTime);
        }
      },
    );
  }

  Widget buildListSortOrderSelector(
      BuildContext context, AppSettingsTableData? settings) {
    return ListTile(
      title: const Text('ফর্দ সাজানোর নিয়ম'),
      subtitle: Text(_getSortOrderLabel(settings?.listSortOrder ?? 'dateDesc')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () async {
        final sortOptions = ['dateDesc', 'dateAsc', 'nameAsc', 'nameDesc'];
        final selectedIndex =
            sortOptions.indexOf(settings?.listSortOrder ?? 'dateDesc');

        final selected = await showMenu<String>(
          context: context,
          initialValue: sortOptions[selectedIndex],
          items: sortOptions
              .map((option) => PopupMenuItem<String>(
                    value: option,
                    child: Text(_getSortOrderLabel(option)),
                  ))
              .toList(),
        );

        if (selected != null) {
          ref
              .read(settingsViewModelProvider.notifier)
              .updateListSortOrder(selected);
        }
      },
    );
  }

  Widget buildPersonalItemsSection(BuildContext context,
      List<ItemTemplate> customItems, SettingsViewModel viewModel) {
    if (customItems.isEmpty) {
      return buildSection(
        title: 'নিজস্ব আইটেম',
        children: [
          Text(
            'এখনো কোনো নিজস্ব আইটেম নেই',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
    }

    return buildSection(
      title: 'নিজস্ব আইটেম',
      children: [
        ...customItems.map((item) => ListTile(
              title: Text(item.nameBangla),
              subtitle: Text('${item.defaultQuantity} ${item.defaultUnit}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _showDeleteConfirmDialog(context, item, viewModel);
                },
              ),
            )),
      ],
    );
  }

  Widget buildAboutSection(BuildContext context) {
    final version = AppVersionCache.current?.version ?? '...';
    final buildNumber = AppVersionCache.current?.buildNumber ?? '...';

    return buildSection(
      title: 'সম্পর্কিত',
      children: [
        ListTile(
          title: const Text('অ্যাপ সংস্করণ'),
          subtitle: Text('ভার্সন $version ($buildNumber)'),
          leading: const Icon(Icons.info_outline),
        ),
        ListTile(
          title: const Text('ডেভেলপার'),
          subtitle: const Text('একুশ ডিজিটাল'),
          leading: const Icon(Icons.code),
        ),
      ],
    );
  }

  Widget buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmDialog(
      BuildContext context, ItemTemplate item, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('আইটেম মুছে ফেলতে'),
        content: Text('${item.nameBangla} আইটেমটি মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          TextButton(
            onPressed: () {
              if (!mounted) return;
              Navigator.pop(context);
              viewModel.deleteCustomItem(item.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('মুছে ফেলতে'),
          ),
        ],
      ),
    );
  }

  String _getSortOrderLabel(String sortOrder) {
    switch (sortOrder) {
      case 'dateDesc':
        return 'তারিখের ক্রমণে (নতুন)';
      case 'dateAsc':
        return 'তারিখের ক্রমণে (পুরন)';
      case 'nameAsc':
        return 'নামের অনুসারে (ক-হ)';
      case 'nameDesc':
        return 'নামের অনুসারে (হ-ক)';
      default:
        return sortOrder;
    }
  }
}
