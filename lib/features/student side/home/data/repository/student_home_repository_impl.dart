import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repository/student_home_repository.dart';
import '../data source/student_home_ds.dart';

class StudentHomeRepositoryImpl implements StudentHomeRepository {
  final StudentHomeDs _remote;
  const StudentHomeRepositoryImpl(this._remote);

  @override
  Future<List<SubjectEntity>> getSubjects() async {
    try {
      return await _remote.getSubjects();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<StudentCourseEntity>> getCourses({
    String? subject,
    int pageSize = 10,
  }) async {
    try {
      return await _remote.getCourses(subject: subject, pageSize: pageSize);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<StudentBookingEntity>> getBookings({
    String? status,
    int pageSize = 3,
  }) async {
    try {
      return await _remote.getBookings(status: status, pageSize: pageSize);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
