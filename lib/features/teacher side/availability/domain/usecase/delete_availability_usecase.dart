import 'package:dartz/dartz.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import '../repository/availability_repository.dart';

class DeleteAvailabilityUseCase {
  final AvailabilityRepository _repository;
  DeleteAvailabilityUseCase(this._repository);

  Future<Either<Failure, Unit>> call(int id) =>
      _repository.deleteAvailability(id);
}