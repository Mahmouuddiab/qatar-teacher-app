import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import '../../domain/entity/teacher_profile_entity.dart';
import '../../domain/repository/student_explore_repository.dart';
import '../data source/student_explore_ds.dart';

class StudentExploreRepositoryImpl implements StudentExploreRepository {
  final StudentExploreDs _remote;
  const StudentExploreRepositoryImpl(this._remote);

  /// Runs [action] and converts ServerException into ServerFailure.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<StudentCourseEntity>> getCourses({
    String? subject,
    int? teacherId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) => _guard(
    () => _remote.getCourses(
      subject: subject,
      teacherId: teacherId,
      search: search,
      page: page,
      pageSize: pageSize,
    ),
  );

  @override
  Future<StudentCourseEntity> getCourseById(int id) =>
      _guard(() => _remote.getCourseById(id));

  @override
  Future<List<String>> getSubjects() => _guard(() => _remote.getSubjects());

  @override
  Future<TeacherProfileEntity> getTeacherById(int id) =>
      _guard(() => _remote.getTeacherById(id));

  @override
  Future<List<StudentCourseEntity>> searchCourses({
    required String keyword,
    String? subject,
    int page = 1,
    int pageSize = 10,
  }) => _guard(
    () => _remote.searchCourses(
      keyword: keyword,
      subject: subject,
      page: page,
      pageSize: pageSize,
    ),
  );
}
