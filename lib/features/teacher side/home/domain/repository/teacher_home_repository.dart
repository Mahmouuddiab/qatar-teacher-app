import 'package:qatar_teachers/core/params/add_course_params.dart';
import '../entities/course_entity.dart';

abstract class TeacherHomeRepository {
  Future<CourseEntity> addCourse(AddCourseParams params);
}