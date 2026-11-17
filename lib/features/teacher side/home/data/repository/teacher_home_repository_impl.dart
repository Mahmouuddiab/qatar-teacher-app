import 'package:qatar_teachers/core/params/add_course_params.dart';
import 'package:qatar_teachers/core/params/update_course_params.dart';
import 'package:qatar_teachers/features/teacher%20side/home/domain/entities/course_entity.dart';
import 'package:qatar_teachers/features/teacher%20side/home/domain/repository/teacher_home_repository.dart';
import '../data source/teacher_home_remote_ds.dart';

class TeacherHomeRepositoryImpl implements TeacherHomeRepository {
  final TeacherHomeRemoteDataSource _remote;
  const TeacherHomeRepositoryImpl(this._remote);
  @override
  Future<CourseEntity> addCourse(AddCourseParams params) async {
    return await _remote.addCourse(params);
  }

  @override
  Future<List<CourseEntity>> getCourses() async {
    return await _remote.getCourses();
  }

  @override
  Future<CourseEntity> getCourseDetails(int id) async {
    return await _remote.getCourseDetails(id);
  }

  @override
  Future<CourseEntity> updateCourse(UpdateCourseParams params) async{
    return await _remote.updateCourse(params);
  }

  @override
  Future<void> deleteCourse(int id) async{
    return await _remote.deleteCourse(id);
  }
}
