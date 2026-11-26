import '../repository/student_explore_repository.dart';

class GetSubjectsUseCase {
  final StudentExploreRepository _repository;
  const GetSubjectsUseCase(this._repository);

  Future<List<String>> call() => _repository.getSubjects();
}