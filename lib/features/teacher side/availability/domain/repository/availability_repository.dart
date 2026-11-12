import 'package:dartz/dartz.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import '../entity/availability_entity.dart';

abstract class AvailabilityRepository {
  Future<Either<Failure, AvailabilityEntity>> addAvailability(
    AvailabilityEntity availability,
  );
  Future<Either<Failure, List<AvailabilityEntity>>> getAvailabilities();
  Future<Either<Failure, Unit>> deleteAvailability(int id);
}
