import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class BanglaDateFormatter {
  static const List<String> _banglaMonths = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর'
  ];

  static const List<String> _banglaDigits = [
    '০',
    '১',
    '২',
    '৩',
    '৪',
    '৫',
    '৬',
    '৭',
    '৮',
    '৯'
  ];

  static String _toBanglaDigits(String text) {
    String result = text;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(i.toString(), _banglaDigits[i]);
    }
    return result;
  }

  static String formatDate(DateTime date) {
    final day = date.day;
    final month = _banglaMonths[date.month - 1];
    final year = date.year;

    return '${_toBanglaDigits(day.toString())} $month, ${_toBanglaDigits(year.toString())}';
  }

  static String formatShortDate(DateTime date) {
    final day = date.day;
    final month = _banglaMonths[date.month - 1];

    return '${_toBanglaDigits(day.toString())} $month';
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute;
    final period = time.period == DayPeriod.am ? 'এএম' : 'পিএম';

    return '${_toBanglaDigits(hour.toString())}:${_toBanglaDigits(minute.toString().padLeft(2, '0'))} $period';
  }

  static String formatTimeFromString(String timeString) {
    try {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final time = TimeOfDay(hour: hour, minute: minute);
      return formatTime(time);
    } catch (e) {
      return timeString;
    }
  }

  static String getRelativeDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly.isAtSameMomentAs(today)) {
      return 'আজ';
    } else if (dateOnly.isAtSameMomentAs(tomorrow)) {
      return 'আগামীকাল';
    } else if (dateOnly.isAtSameMomentAs(yesterday)) {
      return 'গতকাল';
    } else {
      return formatDate(date);
    }
  }

  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0.00');
    final formatted = formatter.format(amount);
    return '৳ ${_toBanglaDigits(formatted)}';
  }

  static String formatNumber(int number) {
    return _toBanglaDigits(number.toString());
  }
}
