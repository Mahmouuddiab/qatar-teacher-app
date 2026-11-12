import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'availability_providers.dart';

/// State = ids currently being deleted, so only that card shows a spinner.
class DeleteAvailabilityNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  /// Returns an error message, or null on success.
  Future<String?> delete(int id) async {
    if (state.contains(id)) return null;
    state = {...state, id};

    final result = await ref.read(deleteAvailabilityUseCaseProvider)(id);

    state = {...state}..remove(id);

    return result.fold(
          (failure) => failure.message,
          (_) {
        ref.invalidate(availabilitiesProvider); // refresh the list
        return null;
      },
    );
  }
}