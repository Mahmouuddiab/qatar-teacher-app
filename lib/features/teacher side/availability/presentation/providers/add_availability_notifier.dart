import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/availability_entity.dart';
import 'availability_providers.dart';

enum AddAvailabilityStatus { initial, loading, success, failure }

class AddAvailabilityState {
  final AddAvailabilityStatus status;
  final AvailabilityEntity? created;
  final String? errorMessage;

  const AddAvailabilityState({
    this.status = AddAvailabilityStatus.initial,
    this.created,
    this.errorMessage,
  });

  bool get isLoading => status == AddAvailabilityStatus.loading;
}

class AddAvailabilityNotifier extends Notifier<AddAvailabilityState> {
  @override
  AddAvailabilityState build() => const AddAvailabilityState();

  Future<void> submit(AvailabilityEntity availability) async {
    if (state.isLoading) return;
    state = const AddAvailabilityState(status: AddAvailabilityStatus.loading);

    final result = await ref.read(addAvailabilityUseCaseProvider)(availability);

    state = result.fold(
          (failure) => AddAvailabilityState(
        status: AddAvailabilityStatus.failure,
        errorMessage: failure.message,
      ),
          (created) => AddAvailabilityState(
        status: AddAvailabilityStatus.success,
        created: created,
      ),
    );
  }
}