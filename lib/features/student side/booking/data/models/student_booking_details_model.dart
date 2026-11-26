import '../../domain/entities/student_booking_details_entity.dart';

List<String> _strings(dynamic v) =>
    (v as List? ?? const []).map((e) => e.toString()).toList();

class StudentBookingDetailsModel extends StudentBookingDetailsEntity {
  const StudentBookingDetailsModel({
    required super.id,
    required super.status,
    required super.mode,
    required super.subject,
    required super.sessionDate,
    required super.sessionEndDate,
    required super.durationMinutes,
    required super.totalPriceQAR,
    required super.createdAt,
    required super.canCancel,
    required super.teacher,
    required super.course,
  });

  factory StudentBookingDetailsModel.fromJson(Map<String, dynamic> json) {
    final t = (json['teacher'] ?? const {}) as Map<String, dynamic>;
    final c = (json['course'] ?? const {}) as Map<String, dynamic>;
    final start = DateTime.parse(json['sessionDate'] as String);
    final duration = (json['durationMinutes'] ?? 0) as int;

    return StudentBookingDetailsModel(
      id: (json['id'] ?? 0) as int,
      status: (json['status'] ?? '').toString(),
      mode: (json['mode'] ?? '').toString(),
      subject: (json['subject'] ?? '').toString(),
      sessionDate: start,
      sessionEndDate: json['sessionEndDate'] != null
          ? DateTime.parse(json['sessionEndDate'] as String)
          : start.add(Duration(minutes: duration)),
      durationMinutes: duration,
      totalPriceQAR: (json['totalPriceQAR'] ?? 0) as num,
      createdAt: DateTime.parse(json['createdAt'] as String),
      canCancel: (json['canCancel'] ?? false) as bool,
      teacher: BookingTeacherEntity(
        teacherId: (t['teacherId'] ?? 0) as int,
        name: (t['name'] ?? '').toString(),
        bio: (t['bio'] ?? '').toString(),
        qualifications: (t['qualifications'] ?? '').toString(),
        subjects: _strings(t['subjects']),
        languages: _strings(t['languages']),
        rating: (t['rating'] ?? 0) as num,
        yearsOfExperience: (t['yearsOfExperience'] ?? 0) as int,
      ),
      course: BookingCourseEntity(
        courseId: (c['courseId'] ?? 0) as int,
        title: (c['title'] ?? '').toString(),
        subject: (c['subject'] ?? '').toString(),
        description: (c['description'] ?? '').toString(),
        level: (c['level'] ?? '').toString(),
        pricePerSessionQAR: (c['pricePerSessionQAR'] ?? 0) as num,
        durationMinutes: (c['durationMinutes'] ?? 0) as int,
        sessionMode: (c['sessionMode'] ?? '').toString(),
        isActive: (c['isActive'] ?? false) as bool,
      ),
    );
  }
}
