// lib/base/jhuri_base_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base screen for all Jhuri screens
/// Extends BaseScreen from ekush_core with Jhuri-specific functionality
abstract class JhuriBaseScreen extends ConsumerStatefulWidget {
  const JhuriBaseScreen({super.key});

  @override
  ConsumerState<JhuriBaseScreen> createState();
}

abstract class JhuriBaseScreenState<T extends JhuriBaseScreen>
    extends ConsumerState<T> {
  // Jhuri-specific configurations

  Color? getBackgroundColor() {
    // Use Jhuri's background color based on theme
    final theme = Theme.of(context);
    return theme.colorScheme.surface;
  }

  bool useSafeArea() => true;

  bool resizeToAvoidBottomInset() => true;

  // Jhuri-specific helper methods
  void showJhuriSnackBar({
    required String message,
    SnackBarType type = SnackBarType.info,
  }) {
    if (!mounted) return;

    final color = switch (type) {
      SnackBarType.success => Colors.green,
      SnackBarType.error => Colors.red,
      SnackBarType.warning => Colors.orange,
      SnackBarType.info => Theme.of(context).colorScheme.primary,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              switch (type) {
                SnackBarType.success => Icons.check_circle_outline,
                SnackBarType.error => Icons.error_outline,
                SnackBarType.warning => Icons.warning_amber_outlined,
                SnackBarType.info => Icons.info_outline,
              },
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<bool> showJhuriConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'নিশ্চিত',
    String cancelText = 'বাতিল',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBackgroundColor(),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
      body: SafeArea(
        top: useSafeArea(),
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context);
}

enum SnackBarType {
  success,
  error,
  warning,
  info,
}
