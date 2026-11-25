import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/params/create_booking_params.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';
import '../../domain/repository/student_booking_repository.dart';
import '../data source/student_booking_ds.dart';

class StudentBookingRepositoryImpl implements StudentBookingRepository {
  final StudentBookingDs _remote;
  const StudentBookingRepositoryImpl(this._remote);

  @override
  Future<StudentBookingEntity> createBooking(CreateBookingParams params) async {
    try {
      return await _remote.createBooking(params);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<List<StudentBookingEntity>> getMyBookings({
    String? status,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      return await _remote.getMyBookings(
        status: status,
        page: page,
        pageSize: pageSize,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> cancelBooking(int id) async {
    try {
      await _remote.cancelBooking(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
