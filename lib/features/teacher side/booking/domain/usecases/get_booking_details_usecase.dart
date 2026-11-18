import 'package:qatar_teachers/features/teacher%20side/booking/domain/repository/teacher_booking_repository.dart';
import '../entities/booking_entity.dart';

class GetBookingDetailsUseCase {
  final TeacherBookingRepository _repository;
  const GetBookingDetailsUseCase(this._repository);

  Future<BookingEntity> call(int id) => _repository.getBookingDetails(id);
}