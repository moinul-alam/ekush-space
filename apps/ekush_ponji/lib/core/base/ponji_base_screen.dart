import 'dart:async';
import 'package:ekush_ponji/core/base/base_screen.dart';
import 'package:ekush_ponji/core/notifications/notification_permission_dialog.dart';
import 'package:ekush_ponji/core/notifications/notification_permission_service.dart';

abstract class PonjiBaseScreen extends BaseScreen {
  const PonjiBaseScreen({super.key});
}

abstract class PonjiBaseScreenState<T extends PonjiBaseScreen>
    extends BaseScreenState<T> {
  // ── Notification prompt ────────────────────────────────────

  /// Static flag — persists across screen pushes/pops for the
  /// entire app session. Once the dialog fires (or is skipped
  /// because permission is already granted), no other screen
  /// will trigger it again until the app is restarted.
  static bool _promptShownThisSession = false;
  Timer? _notifPromptTimer;

  /// Seconds to wait after the screen mounts before showing the
  /// notification permission dialog.
  /// Override per screen if you need a different delay.
  /// Defaults to 10 seconds — long enough for the screen to settle
  /// but short enough to feel contextual.
  int get notificationPromptDelaySeconds => 10;

  void _scheduleNotificationPrompt() {
    // Already shown once this session — bail out immediately
    if (_promptShownThisSession) return;

    _notifPromptTimer = Timer(
      Duration(seconds: notificationPromptDelaySeconds),
      () async {
        // Permission already granted — nothing to ask
        final already = await NotificationPermissionService.isGranted();
        if (already) {
          // Mark so we never check again this session
          _promptShownThisSession = true;
          return;
        }

        // Screen may have been disposed during the wait
        if (!mounted) return;

        // Mark BEFORE showing — prevents a second screen from
        // racing through while the dialog is still open
        _promptShownThisSession = true;

        await NotificationPermissionDialog.show(context, ref);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scheduleNotificationPrompt();
  }

  @override
  void dispose() {
    _notifPromptTimer?.cancel();
    super.dispose();
  }
}
