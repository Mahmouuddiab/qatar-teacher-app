import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/params/update_teacher_profile.dart';
import '../../domain/usecase/update_teacher_profile.dart';
import 'teacher_profile_providers.dart';

final updateTeacherProfileUseCaseProvider =
    Provider<UpdateTeacherProfileUseCase>((ref) {
      final repository = ref.watch(teacherProfileRepositoryProvider);

      return UpdateTeacherProfileUseCase(repository);
    });

class EditTeacherProfileNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<bool> save(UpdateTeacherProfileParams params) async {
    final link = ref.keepAlive();

    try {
      state = const AsyncLoading();

      state = await AsyncValue.guard(
        () => ref.read(updateTeacherProfileUseCaseProvider).call(params),
      );

      if (state.hasError) return false;

      ref.invalidate(teacherProfileProvider);
      return true;
    } finally {
      link.close();
    }
  }
}

final editTeacherProfileProvider =
    AsyncNotifierProvider.autoDispose<EditTeacherProfileNotifier, void>(
      EditTeacherProfileNotifier.new,
    );
