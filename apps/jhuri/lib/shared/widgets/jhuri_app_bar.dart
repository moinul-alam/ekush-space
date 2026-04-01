import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JhuriAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const JhuriAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      actions: actions,
      leading: leading ??
          Builder(
            builder: (context) {
              final scaffold = Scaffold.maybeOf(context);
              final canPop = context.canPop();

              if (canPop) {
                return IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => context.pop(),
                );
              }

              if (scaffold?.hasDrawer ?? false) {
                return IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: () => scaffold?.openDrawer(),
                );
              }

              return const SizedBox.shrink();
            },
          ),
      centerTitle: centerTitle,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shape: Border(
        bottom: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
