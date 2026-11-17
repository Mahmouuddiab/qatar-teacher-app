import 'package:qatar_teachers/core/params/update_course_params.dart';
import '../entities/course_entity.dart';
import '../repository/teacher_home_repository.dart';

class UpdateCourseUseCase {
  final TeacherHomeRepository repository;
  const UpdateCourseUseCase(this.repository);

  Future<CourseEntity> call(UpdateCourseParams params) =>
      repository.updateCourse(params);
}