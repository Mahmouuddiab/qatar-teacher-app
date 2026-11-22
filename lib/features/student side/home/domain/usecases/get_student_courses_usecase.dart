import '../entities/student_course_entity.dart';
import '../repository/student_home_repository.dart';

class GetStudentCoursesUseCase {
  final StudentHomeRepository _repository;
  const GetStudentCoursesUseCase(this._repository);

  Future<List<StudentCourseEntity>> call({String? subject, int pageSize = 10}) =>
      _repository.getCourses(subject: subject, pageSize: pageSize);
}