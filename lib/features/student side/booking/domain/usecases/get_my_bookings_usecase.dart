import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';
import '../repository/student_booking_repository.dart';

class GetMyBookingsUseCase {
  final StudentBookingRepository _repository;
  const GetMyBookingsUseCase(this._repository);

  Future<List<StudentBookingEntity>> call({
    String? status,
    int page = 1,
    int pageSize = 50,
  }) =>
      _repository.getMyBookings(status: status, page: page, pageSize: pageSize);
}
