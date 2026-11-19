import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/features/teacher%20side/booking/data/data%20source/teacher_booking_ds.dart';
import 'package:qatar_teachers/features/teacher%20side/booking/domain/entities/booking_entity.dart';
import 'package:qatar_teachers/features/teacher%20side/booking/domain/repository/teacher_booking_repository.dart';

class TeacherBookingRepositoryImpl implements TeacherBookingRepository {
  final TeacherBookingDs _remote;
  const TeacherBookingRepositoryImpl(this._remote);
  @override
  Future<List<BookingEntity>> getBookings() async {
    return await _remote.getBookings();
  }

  @override
  Future<BookingEntity> getBookingDetails(int id) async {
    return await _remote.getBookingDetails(id);
  }

  @override
  Future<void> respondToBooking(int id, bool accept) async {
    try {
      await _remote.respondToBooking(id, accept);
    } on ServerException {
      throw const ServerFailure('Failed to update booking');
    }
  }

  @override
  Future<void> completeBooking(int id) async {
    try {
      await _remote.completeBooking(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
