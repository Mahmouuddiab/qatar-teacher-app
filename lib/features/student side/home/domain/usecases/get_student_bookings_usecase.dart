import '../entities/student_booking_entity.dart';
import '../repository/student_home_repository.dart';

class GetStudentBookingsUseCase {
  final StudentHomeRepository _repository;
  const GetStudentBookingsUseCase(this._repository);

  Future<List<StudentBookingEntity>> call({String? status, int pageSize = 3}) =>
      _repository.getBookings(status: status, pageSize: pageSize);
}