import '../entities/student_booking_entity.dart';
import '../entities/student_course_entity.dart';
import '../entities/subject_entity.dart';

abstract class StudentHomeRepository {
  Future<List<SubjectEntity>> getSubjects();
  Future<List<StudentCourseEntity>> getCourses({
    String? subject,
    int pageSize = 10,
  });
  Future<List<StudentBookingEntity>> getBookings({
    String? status,
    int pageSize = 3,
  });
}