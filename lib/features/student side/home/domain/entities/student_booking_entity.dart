class StudentBookingEntity {
  final int id;
  final int teacherId;
  final String teacherName;
  final int courseId;
  final String mode;
  final String subject;
  final DateTime sessionDate;
  final num totalPriceQAR;
  final String status;

  const StudentBookingEntity({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.courseId,
    required this.mode,
    required this.subject,
    required this.sessionDate,
    required this.totalPriceQAR,
    required this.status,
  });
}