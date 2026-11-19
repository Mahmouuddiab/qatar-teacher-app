import '../repository/teacher_booking_repository.dart';

class CompleteBookingUseCase {
  final TeacherBookingRepository _repository;
  const CompleteBookingUseCase(this._repository);

  Future<void> call(int id) => _repository.completeBooking(id);
}