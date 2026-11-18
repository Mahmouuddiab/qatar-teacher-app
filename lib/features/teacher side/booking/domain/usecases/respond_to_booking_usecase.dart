import '../repository/teacher_booking_repository.dart';

class RespondToBookingUseCase {
  final TeacherBookingRepository _repository;
  const RespondToBookingUseCase(this._repository);

  Future<void> call(int id, bool accept) =>
      _repository.respondToBooking(id, accept);
}
