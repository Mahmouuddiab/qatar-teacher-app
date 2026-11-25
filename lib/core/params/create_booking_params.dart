class CreateBookingParams {
  final int courseId;
  final DateTime sessionDate; // local time
  final String mode; // Online | InPerson

  const CreateBookingParams({
    required this.courseId,
    required this.sessionDate,
    required this.mode,
  });

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// Sent without "Z", like the values that worked in Swagger
  /// (e.g. 2026-11-26T17:00:00).
  String get _isoLocal =>
      '${sessionDate.year.toString().padLeft(4, '0')}-${_two(sessionDate.month)}-${_two(sessionDate.day)}'
          'T${_two(sessionDate.hour)}:${_two(sessionDate.minute)}:00';

  Map<String, dynamic> toJson() => {
    'courseId': courseId,
    'sessionDate': _isoLocal,
    'mode': mode,
  };
}