import '../entities/student_booking_details_entity.dart';
import '../repository/student_booking_repository.dart';

class GetStudentBookingDetailsUseCase {
  final StudentBookingRepository _repository;
  const GetStudentBookingDetailsUseCase(this._repository);

  Future<StudentBookingDetailsEntity> call(int id) =>
      _repository.getBookingDetails(id);
}