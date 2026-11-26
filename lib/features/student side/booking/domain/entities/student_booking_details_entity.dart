class BookingTeacherEntity {
  final int teacherId;
  final String name;
  final String bio;
  final String qualifications;
  final List<String> subjects;
  final List<String> languages;
  final num rating;
  final int yearsOfExperience;

  const BookingTeacherEntity({
    required this.teacherId,
    required this.name,
    required this.bio,
    required this.qualifications,
    required this.subjects,
    required this.languages,
    required this.rating,
    required this.yearsOfExperience,
  });
}

class BookingCourseEntity {
  final int courseId;
  final String title;
  final String subject;
  final String description;
  final String level;
  final num pricePerSessionQAR;
  final int durationMinutes;
  final String sessionMode;
  final bool isActive;

  const BookingCourseEntity({
    required this.courseId,
    required this.title,
    required this.subject,
    required this.description,
    required this.level,
    required this.pricePerSessionQAR,
    required this.durationMinutes,
    required this.sessionMode,
    required this.isActive,
  });
}

class StudentBookingDetailsEntity {
  final int id;
  final String status;
  final String mode;
  final String subject;
  final DateTime sessionDate;
  final DateTime sessionEndDate;
  final int durationMinutes;
  final num totalPriceQAR;
  final DateTime createdAt;
  final bool canCancel;
  final BookingTeacherEntity teacher;
  final BookingCourseEntity course;

  const StudentBookingDetailsEntity({
    required this.id,
    required this.status,
    required this.mode,
    required this.subject,
    required this.sessionDate,
    required this.sessionEndDate,
    required this.durationMinutes,
    required this.totalPriceQAR,
    required this.createdAt,
    required this.canCancel,
    required this.teacher,
    required this.course,
  });
}