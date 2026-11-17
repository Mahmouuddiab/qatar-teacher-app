import 'package:qatar_teachers/core/params/add_course_params.dart';
import 'package:qatar_teachers/core/params/update_course_params.dart';
import '../entities/course_entity.dart';

abstract class TeacherHomeRepository {
  Future<CourseEntity> addCourse(AddCourseParams params);
  Future<List<CourseEntity>> getCourses();
  Future<CourseEntity> getCourseDetails(int id);
  Future<CourseEntity> updateCourse(UpdateCourseParams params);
  Future<void> deleteCourse(int id);
}