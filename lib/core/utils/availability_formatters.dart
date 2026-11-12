import '../../features/teacher side/availability/domain/entity/availability_entity.dart';

class AvailabilityFormatters {
  AvailabilityFormatters._();

  static const dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  /// "Every Sunday" for weekly slots, "Sunday, 2026-11-15" for one-time slots.
  static String title(AvailabilityEntity slot) {
    if (slot.isRecurring) {
      final day = slot.dayOfWeek;
      return day == null ? 'Weekly' : 'Every ${dayNames[day % 7]}';
    }

    final d = slot.date;
    if (d == null) return 'One time';

    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '${dayNames[d.weekday % 7]}, ${d.year}-$mm-$dd';
  }

  /// "09:00" -> "9:00 AM"
  static String to12Hour(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length < 2) return hhmm;

    final h = int.tryParse(parts[0]);
    if (h == null) return hhmm;

    final period = h >= 12 ? 'PM' : 'AM';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '$h12:${parts[1]} $period';
  }

  static String timeRange(AvailabilityEntity slot) =>
      '${to12Hour(slot.startTime)} - ${to12Hour(slot.endTime)}';
}
