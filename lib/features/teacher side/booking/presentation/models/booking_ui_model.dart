import 'package:qatar_teachers/features/teacher%20side/booking/domain/entities/booking_entity.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled; // also covers rejected

  String get label => switch (this) {
    BookingStatus.pending => 'Pending',
    BookingStatus.confirmed => 'Confirmed',
    BookingStatus.completed => 'Completed',
    BookingStatus.cancelled => 'Cancelled',
  };
}

enum BookingFilter {
  all('All'),
  pending('Pending'),
  confirmed('Confirmed'),
  completed('Completed'),
  cancelled('Cancelled');

  const BookingFilter(this.label);

  final String label;

  bool matches(BookingStatus status) => switch (this) {
    BookingFilter.all => true,
    BookingFilter.pending => status == BookingStatus.pending,
    BookingFilter.confirmed => status == BookingStatus.confirmed,
    BookingFilter.completed => status == BookingStatus.completed,
    BookingFilter.cancelled => status == BookingStatus.cancelled,
  };
}

class BookingUiModel {
  final int id;
  final String studentName;
  final String subject;
  final String dateLabel;
  final String timeLabel;
  final String price;
  final BookingStatus status;

  const BookingUiModel({
    required this.id,
    required this.studentName,
    required this.subject,
    required this.dateLabel,
    required this.timeLabel,
    required this.price,
    required this.status,
  });

  factory BookingUiModel.fromEntity(BookingEntity e) {
    return BookingUiModel(
      id: e.id,
      studentName: e.studentName,
      subject: e.subject,
      dateLabel: _formatDate(e.sessionDate),
      timeLabel: _formatTime(e.sessionDate),
      price: 'QAR ${_formatPrice(e.totalPriceQAR)}',
      status: _statusFrom(e.status),
    );
  }

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// "Thu, 26 Nov 2026"
  static String _formatDate(DateTime d) {
    final l = d.toLocal();
    return '${_days[l.weekday - 1]}, ${l.day} ${_months[l.month - 1]} ${l.year}';
  }

  /// "5:00 PM"
  static String _formatTime(DateTime d) {
    final l = d.toLocal();
    final period = l.hour >= 12 ? 'PM' : 'AM';
    final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
    return '$h:${l.minute.toString().padLeft(2, '0')} $period';
  }

  static String _formatPrice(num v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);

  static BookingStatus _statusFrom(String s) {
    switch (s.toLowerCase()) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
      case 'canceled':
      case 'rejected':
        return BookingStatus.cancelled;
      case 'pending':
      default:
        return BookingStatus.pending;
    }
  }
}