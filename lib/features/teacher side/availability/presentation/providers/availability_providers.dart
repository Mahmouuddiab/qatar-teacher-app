import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data source/availability_remote_datasource.dart';
import '../../data/repository/availability_repository_impl.dart';
import '../../domain/entity/availability_entity.dart';
import '../../domain/repository/availability_repository.dart';
import '../../domain/usecase/add_availability_usecase.dart';
import '../../domain/usecase/delete_availability_usecase.dart';
import '../../domain/usecase/get_availabilities_usecase.dart';
import 'add_availability_notifier.dart';
import 'delete_availability_notifier.dart';

final availabilityDsProvider = Provider<TeacherAvailabilityDs>(
      (ref) => TeacherAvailabilityDsImpl(),
);

final availabilityRepositoryProvider = Provider<AvailabilityRepository>(
      (ref) => AvailabilityRepositoryImpl(ref.watch(availabilityDsProvider)),
);

final addAvailabilityUseCaseProvider = Provider<AddAvailabilityUseCase>(
      (ref) => AddAvailabilityUseCase(ref.watch(availabilityRepositoryProvider)),
);

final getAvailabilitiesUseCaseProvider = Provider<GetAvailabilitiesUseCase>(
      (ref) => GetAvailabilitiesUseCase(ref.watch(availabilityRepositoryProvider)),
);

final deleteAvailabilityUseCaseProvider = Provider<DeleteAvailabilityUseCase>(
      (ref) => DeleteAvailabilityUseCase(ref.watch(availabilityRepositoryProvider)),
);

final addAvailabilityProvider =
NotifierProvider.autoDispose<AddAvailabilityNotifier, AddAvailabilityState>(
  AddAvailabilityNotifier.new,
);

final deleteAvailabilityProvider =
NotifierProvider.autoDispose<DeleteAvailabilityNotifier, Set<int>>(
  DeleteAvailabilityNotifier.new,
);

final availabilitiesProvider =
FutureProvider.autoDispose<List<AvailabilityEntity>>((ref) async {
  final result = await ref.watch(getAvailabilitiesUseCaseProvider)();
  return result.fold(
        (failure) => throw Exception(failure.message),
        (list) => list,
  );
});