import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import '../repository/student_explore_repository.dart';

class GetCoursesUseCase {
  final StudentExploreRepository _repository;
  const GetCoursesUseCase(this._repository);

  Future<List<StudentCourseEntity>> call({
    String? subject,
    int? teacherId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) =>
      _repository.getCourses(
        subject: subject,
        teacherId: teacherId,
        search: search,
        page: page,
        pageSize: pageSize,
      );
}