import 'package:dartz/dartz.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import '../entity/availability_entity.dart';
import '../repository/availability_repository.dart';

class GetAvailabilitiesUseCase {
  final AvailabilityRepository _repository;
  GetAvailabilitiesUseCase(this._repository);

  Future<Either<Failure, List<AvailabilityEntity>>> call() =>
      _repository.getAvailabilities();
}