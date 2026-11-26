import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import '../repository/student_explore_repository.dart';

class GetCourseByIdUseCase {
  final StudentExploreRepository _repository;
  const GetCourseByIdUseCase(this._repository);

  Future<StudentCourseEntity> call(int id) => _repository.getCourseById(id);
}