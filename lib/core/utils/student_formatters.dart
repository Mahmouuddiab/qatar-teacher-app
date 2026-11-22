/// Display formatting that used to live in home_ui_models.dart.
/// Call these from the cards instead of mapping entities to UI models.
library;

const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

extension SessionDateFormat on DateTime {
  /// e.g. "Sun, 22 Nov"
  String get sessionDateLabel => '${_days[weekday - 1]}, $day ${_months[month - 1]}';

  /// e.g. "9:05 AM"
  String get sessionTimeLabel {
    final period = hour >= 12 ? 'PM' : 'AM';
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return '$h:${minute.toString().padLeft(2, '0')} $period';
  }
}

extension QarFormat on num {
  /// e.g. "QAR 120" or "QAR 99.50"
  String get qarLabel =>
      'QAR ${this == roundToDouble() ? toInt() : toStringAsFixed(2)}';
}