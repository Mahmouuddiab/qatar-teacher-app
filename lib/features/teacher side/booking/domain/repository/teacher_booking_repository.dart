import '../entities/booking_entity.dart';

abstract class TeacherBookingRepository {
  Future<List<BookingEntity>> getBookings();
  Future<BookingEntity> getBookingDetails(int id);
  Future<void> respondToBooking(int id, bool accept);
  Future<void> completeBooking(int id);
}