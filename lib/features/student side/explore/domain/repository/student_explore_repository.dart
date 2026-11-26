import '../../../home/domain/entities/student_course_entity.dart';
import '../entity/teacher_profile_entity.dart';

abstract class StudentExploreRepository {
  Future<List<StudentCourseEntity>> getCourses({
    String? subject,
    int? teacherId,
    String? search,
    int page = 1,
    int pageSize = 10,
  });
  Future<StudentCourseEntity> getCourseById(int id);
  Future<List<String>> getSubjects();
  Future<TeacherProfileEntity> getTeacherById(int id);
  Future<List<StudentCourseEntity>> searchCourses({
    required String keyword,
    String? subject,
    int page = 1,
    int pageSize = 10,
  });
}