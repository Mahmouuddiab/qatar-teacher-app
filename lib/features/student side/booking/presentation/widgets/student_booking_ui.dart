import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';

enum MyBookingStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  completed('Completed'),
  cancelled('Cancelled'); // also covers rejected

  const MyBookingStatus(this.label);
  final String label;

  static MyBookingStatus from(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return confirmed;
      case 'completed':
        return completed;
      case 'cancelled':
      case 'canceled':
      case 'rejected':
        return cancelled;
      default:
        return pending;
    }
  }
}

enum MyBookingFilter {
  all('All'),
  pending('Pending'),
  confirmed('Confirmed'),
  completed('Completed'),
  cancelled('Cancelled');

  const MyBookingFilter(this.label);
  final String label;

  bool matches(MyBookingStatus s) => switch (this) {
    MyBookingFilter.all => true,
    MyBookingFilter.pending => s == MyBookingStatus.pending,
    MyBookingFilter.confirmed => s == MyBookingStatus.confirmed,
    MyBookingFilter.completed => s == MyBookingStatus.completed,
    MyBookingFilter.cancelled => s == MyBookingStatus.cancelled,
  };
}

extension StudentBookingView on StudentBookingEntity {
  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  MyBookingStatus get statusUi => MyBookingStatus.from(status);

  String get dateLabel =>
      '${_days[sessionDate.weekday - 1]}, ${sessionDate.day} ${_months[sessionDate.month - 1]} ${sessionDate.year}';

  String get timeLabel {
    final period = sessionDate.hour >= 12 ? 'PM' : 'AM';
    final h = sessionDate.hour % 12 == 0 ? 12 : sessionDate.hour % 12;
    return '$h:${sessionDate.minute.toString().padLeft(2, '0')} $period';
  }

  String get priceLabel =>
      'QAR ${totalPriceQAR == totalPriceQAR.roundToDouble() ? totalPriceQAR.toInt() : totalPriceQAR.toStringAsFixed(2)}';
}