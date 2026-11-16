import 'package:qatar_teachers/core/params/add_course_params.dart';
import 'package:qatar_teachers/features/teacher%20side/home/domain/repository/teacher_home_repository.dart';
import '../entities/course_entity.dart';

class AddCourseUseCase {
  final TeacherHomeRepository _repository;

  const AddCourseUseCase(this._repository);

  Future<CourseEntity> call(AddCourseParams params) {
    return _repository.addCourse(params);
  }
}
