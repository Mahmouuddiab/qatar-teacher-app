import 'package:qatar_teachers/core/params/create_booking_params.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';
import '../repository/student_booking_repository.dart';

class CreateBookingUseCase {
  final StudentBookingRepository _repository;
  const CreateBookingUseCase(this._repository);

  Future<StudentBookingEntity> call(CreateBookingParams params) =>
      _repository.createBooking(params);
}