import '../entities/subject_entity.dart';
import '../repository/student_home_repository.dart';

class GetSubjectsUseCase {
  final StudentHomeRepository _repository;
  const GetSubjectsUseCase(this._repository);

  Future<List<SubjectEntity>> call() => _repository.getSubjects();
}