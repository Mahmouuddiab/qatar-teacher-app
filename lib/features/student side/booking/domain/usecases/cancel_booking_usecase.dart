import '../repository/student_booking_repository.dart';

class CancelBookingUseCase {
  final StudentBookingRepository _repository;
  const CancelBookingUseCase(this._repository);

  Future<void> call(int id) => _repository.cancelBooking(id);
}