import 'package:qatar_teachers/features/teacher%20side/booking/domain/repository/teacher_booking_repository.dart';
import '../entities/booking_entity.dart';

class GetBookingsUseCase {
  final TeacherBookingRepository _repository;
  const GetBookingsUseCase(this._repository);

  Future<List<BookingEntity>> call() => _repository.getBookings();
}
