import '../entities/course_entity.dart';
import '../repository/teacher_home_repository.dart';

class GetCoursesUseCase {
  final TeacherHomeRepository repository;
  const GetCoursesUseCase(this.repository);

  Future<List<CourseEntity>> call() => repository.getCourses();
}
