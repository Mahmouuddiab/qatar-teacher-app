import 'package:qatar_teachers/core/params/create_booking_params.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';

abstract class StudentBookingRepository {
  Future<StudentBookingEntity> createBooking(CreateBookingParams params);
  Future<List<StudentBookingEntity>> getMyBookings({
    String? status,
    int page = 1,
    int pageSize = 50,
  });
  Future<void> cancelBooking(int id);
}