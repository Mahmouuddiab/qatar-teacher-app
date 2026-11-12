import 'package:dartz/dartz.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import '../../domain/entity/availability_entity.dart';
import '../../domain/repository/availability_repository.dart';
import '../data source/availability_remote_datasource.dart';
import '../models/availability_model.dart';

class AvailabilityRepositoryImpl implements AvailabilityRepository {
  final TeacherAvailabilityDs _ds;
  AvailabilityRepositoryImpl(this._ds);

  String _msg(Object e) => e.toString().replaceFirst('Exception: ', '');

  @override
  Future<Either<Failure, AvailabilityEntity>> addAvailability(
      AvailabilityEntity availability) async {
    try {
      final created =
      await _ds.addAvailability(AvailabilityModel.fromEntity(availability));
      return Right(created);
    } catch (e) {
      return Left(ServerFailure(_msg(e)));
    }
  }

  @override
  Future<Either<Failure, List<AvailabilityEntity>>> getAvailabilities() async {
    try {
      return Right(await _ds.getAvailabilities());
    } catch (e) {
      return Left(ServerFailure(_msg(e)));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAvailability(int id) async {
    try {
      await _ds.deleteAvailability(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(_msg(e)));
    }
  }
}