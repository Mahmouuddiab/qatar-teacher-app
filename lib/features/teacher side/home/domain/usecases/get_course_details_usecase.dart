import '../entities/course_entity.dart';
import '../repository/teacher_home_repository.dart';

class GetCourseDetailsUseCase {
  final TeacherHomeRepository repository;
  const GetCourseDetailsUseCase(this.repository);

  Future<CourseEntity> call(int id) => repository.getCourseDetails(id);
}