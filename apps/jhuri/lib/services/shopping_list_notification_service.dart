// lib/services/shopping_list_notification_service.dart

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:ekush_notifications/ekush_notifications.dart';
import '../features/shopping_list/data/shopping_list_repository.dart';
import '../features/list_item/data/list_item_repository.dart';

/// Service for managing shopping list notifications
class ShoppingListNotificationService {
  static const String _notificationTitle = 'আজ বাজার আছে';
  static const String _notificationPrefix = 'আপনার ফর্দে ';
  static const String _notificationSuffix = 'টি আইটেম আছে';

  /// Schedule notification for a shopping list
  static Future<void> scheduleNotification({
    required int listId,
    required DateTime buyDate,
    required String reminderTime,
    required ShoppingListRepository listRepository,
    required ListItemRepository itemRepository,
  }) async {
    try {
      // Parse reminder time (format: "HH:mm")
      final timeParts = reminderTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Create scheduled time in Asia/Dhaka timezone
      final scheduledTime = tz.TZDateTime(
        tz.getLocation('Asia/Dhaka'),
        buyDate.year,
        buyDate.month,
        buyDate.day,
        hour,
        minute,
      );

      // Get item count for the notification body
      final itemCount = await itemRepository.getTotalCount(listId);
      final body = '$_notificationPrefix$itemCount$_notificationSuffix';

      // Create notification details
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          'jhuri_shopping_lists',
          'Shopping List Reminders',
          channelDescription: 'Notifications for shopping lists',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      );

      // Schedule the notification with deep link payload
      await LocalNotificationService.scheduleZoned(
        id: listId,
        scheduledTime: scheduledTime,
        title: _notificationTitle,
        body: body,
        details: details,
        payload: 'jhuri://list/$listId/shopping', // Deep link to shopping mode
      );

      debugPrint('✅ Scheduled notification for list $listId at $scheduledTime');
    } catch (e) {
      debugPrint('❌ Failed to schedule notification for list $listId: $e');
    }
  }

  /// Cancel notification for a shopping list
  static Future<void> cancelNotification(int listId) async {
    try {
      await LocalNotificationService.cancel(listId);
      debugPrint('✅ Cancelled notification for list $listId');
    } catch (e) {
      debugPrint('❌ Failed to cancel notification for list $listId: $e');
    }
  }

  /// Reschedule notification for a shopping list (used when reminder time changes)
  static Future<void> rescheduleNotification({
    required int listId,
    required DateTime buyDate,
    required String newReminderTime,
    required ShoppingListRepository listRepository,
    required ListItemRepository itemRepository,
  }) async {
    // Cancel existing notification
    await cancelNotification(listId);

    // Schedule new notification
    await scheduleNotification(
      listId: listId,
      buyDate: buyDate,
      reminderTime: newReminderTime,
      listRepository: listRepository,
      itemRepository: itemRepository,
    );
  }

  /// Schedule notifications for all active lists (called on app start or settings change)
  static Future<void> scheduleAllActiveNotifications({
    required ShoppingListRepository listRepository,
    required ListItemRepository itemRepository,
    required String defaultReminderTime,
  }) async {
    try {
      // Get today's and upcoming lists (active, non-completed lists)
      final todayLists = await listRepository.getTodayLists();
      final upcomingLists = await listRepository.getUpcomingLists();
      final activeLists = [...todayLists, ...upcomingLists];

      for (final list in activeLists) {
        // Use list-specific reminder time if set, otherwise use default
        String reminderTime = defaultReminderTime;
        if (list.reminderTime != null) {
          reminderTime =
              '${list.reminderTime!.hour.toString().padLeft(2, '0')}:${list.reminderTime!.minute.toString().padLeft(2, '0')}';
        }

        // Only schedule if buy date is in the future
        if (list.buyDate.isAfter(DateTime.now())) {
          await scheduleNotification(
            listId: list.id,
            buyDate: list.buyDate,
            reminderTime: reminderTime,
            listRepository: listRepository,
            itemRepository: itemRepository,
          );
        }
      }

      debugPrint(
          '✅ Scheduled notifications for ${activeLists.length} active lists');
    } catch (e) {
      debugPrint('❌ Failed to schedule all active notifications: $e');
    }
  }

  /// Cancel all shopping list notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await LocalNotificationService.cancelAll();
      debugPrint('✅ Cancelled all shopping list notifications');
    } catch (e) {
      debugPrint('❌ Failed to cancel all notifications: $e');
    }
  }
}
