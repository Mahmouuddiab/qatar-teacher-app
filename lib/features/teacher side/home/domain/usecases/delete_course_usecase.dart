import '../repository/teacher_home_repository.dart';

class DeleteCourseUseCase {
  final TeacherHomeRepository repository;
  const DeleteCourseUseCase(this.repository);

  Future<void> call(int id) => repository.deleteCourse(id);
}