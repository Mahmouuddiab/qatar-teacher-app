import 'package:dartz/dartz.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import '../entity/availability_entity.dart';
import '../repository/availability_repository.dart';

class AddAvailabilityUseCase {
  final AvailabilityRepository _repository;
  AddAvailabilityUseCase(this._repository);

  Future<Either<Failure, AvailabilityEntity>> call(
    AvailabilityEntity availability,
  ) => _repository.addAvailability(availability);
}
