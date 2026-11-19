import 'package:flutter/material.dart';

/// Icon for each notification type returned by the API.
IconData notificationIcon(String type) => switch (type) {
  'BookingRequested' => Icons.event_available_outlined,
  'BookingConfirmed' => Icons.check_circle_outline,
  'BookingCancelled' => Icons.event_busy_outlined,
  _ => Icons.notifications_none_rounded,
};

/// Arabic text lays out right-to-left even inside an LTR app.
TextDirection textDirectionOf(String text) {
  final first = text.runes.firstWhere((r) => r > 32, orElse: () => 65);
  final isArabic = first >= 0x0600 && first <= 0x06FF;
  return isArabic ? TextDirection.rtl : TextDirection.ltr;
}

/// "Just now", "5 min ago", "3 h ago", "2 d ago", then dd/mm/yyyy.
String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} h ago';
  if (diff.inDays < 7) return '${diff.inDays} d ago';
  return '${date.day}/${date.month}/${date.year}';
}