import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import '../repository/student_explore_repository.dart';

class SearchCoursesUseCase {
  final StudentExploreRepository _repository;
  const SearchCoursesUseCase(this._repository);

  Future<List<StudentCourseEntity>> call({
    required String keyword,
    String? subject,
    int page = 1,
    int pageSize = 10,
  }) =>
      _repository.searchCourses(
        keyword: keyword,
        subject: subject,
        page: page,
        pageSize: pageSize,
      );
}