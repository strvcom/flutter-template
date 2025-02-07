import 'package:flutter/material.dart';
import 'package:flutter_app/common/extension/build_context.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return isSameDay(now);
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(tomorrow);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  String formatDayAgo(BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative || difference.inDays == 0) {
      return context.locale.generalDateToday;
    } else if (difference.inDays >= 1 && difference.inDays < 6) {
      return '${difference.inDays}d';
    } else if (difference.inDays >= 6 && difference.inDays <= 7) {
      return '1w';
    } else {
      return DateFormat.MMMEd().format(this);
    }
  }

  String formatDayFuture(BuildContext context) {
    if (isToday) {
      return context.locale.generalDateToday;
    } else if (isTomorrow) {
      return context.locale.generalDateTomorrow;
    } else {
      return DateFormat.MMMEd().format(this);
    }
  }
}
