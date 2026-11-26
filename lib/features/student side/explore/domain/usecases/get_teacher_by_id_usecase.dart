import '../entity/teacher_profile_entity.dart';
import '../repository/student_explore_repository.dart';

class GetTeacherByIdUseCase {
  final StudentExploreRepository _repository;
  const GetTeacherByIdUseCase(this._repository);

  Future<TeacherProfileEntity> call(int id) => _repository.getTeacherById(id);
}