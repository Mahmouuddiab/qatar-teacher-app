class BookingEntity {
  final int id;
  final int studentId;
  final String studentName;
  final int courseId;
  final String subject;
  final String mode;
  final DateTime sessionDate;
  final num totalPriceQAR;
  final String status;

  const BookingEntity({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.courseId,
    required this.subject,
    required this.mode,
    required this.sessionDate,
    required this.totalPriceQAR,
    required this.status,
  });
}