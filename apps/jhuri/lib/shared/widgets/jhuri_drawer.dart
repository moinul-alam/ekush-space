import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ekush_core/ekush_core.dart';

class JhuriDrawer extends StatelessWidget {
  const JhuriDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        colorScheme.onPrimaryContainer.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_basket_rounded,
                    size: 48,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ঝুড়ি',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        'বাজারের ফর্দ, হাতের মুঠোয়',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerTile(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'হোম',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/');
                  },
                ),
                _DrawerTile(
                  icon: Icons.category_outlined,
                  selectedIcon: Icons.category_rounded,
                  label: 'ক্যাটাগরি',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/categories');
                  },
                ),
                _DrawerTile(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                  label: 'সেটিংস',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/settings');
                  },
                ),
                const Divider(),
                // About Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'অ্যাপ সম্পর্কে',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded),
                  title: const Text('অ্যাপের ভার্সন'),
                  subtitle: Text(AppVersionCache.current?.displayBn ?? '১.০.০'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onPath = GoRouterState.of(context).uri.toString();

    // Simple logic for highlighting active path
    final bool isSelected = (label == 'হোম' && onPath == '/') ||
        (label == 'ক্যাটাগরি' && onPath.startsWith('/categories')) ||
        (label == 'সেটিংস' && onPath.startsWith('/settings'));

    return ListTile(
      leading: Icon(
        isSelected ? selectedIcon : icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? colorScheme.primary : colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
