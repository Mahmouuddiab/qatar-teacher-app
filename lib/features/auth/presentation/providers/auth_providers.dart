import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:qatar_teachers/core/params/login_params.dart';
import 'package:qatar_teachers/core/params/register_params.dart';
import 'package:qatar_teachers/features/auth/data/data%20source/auth_remote_ds.dart';
import 'package:qatar_teachers/features/auth/data/repository/auth_repository_impl.dart';
import 'package:qatar_teachers/features/auth/domain/entity/user_entity.dart';
import 'package:qatar_teachers/features/auth/domain/repository/auth_repository.dart';
import 'package:qatar_teachers/features/auth/domain/usecase/login_usecase.dart';
import 'package:qatar_teachers/features/auth/domain/usecase/register_usecase.dart';

// ---------- Data layer ----------

final authRemoteDsProvider = Provider<AuthRemoteDs>((ref) {
  return AuthRemoteDSImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDsProvider));
});

// ---------- Use cases ----------

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

// ---------- Login ----------

/// Login state: AsyncData(null) = idle, AsyncLoading, AsyncData(user), AsyncError.
final loginStateProvider =
StateProvider.autoDispose<AsyncValue<UserEntity?>>(
      (ref) => const AsyncData(null),
);

/// Call it like a function: `ref.read(loginProvider)(params)`.
/// Returns true on success.
final loginProvider =
Provider.autoDispose<Future<bool> Function(LoginParams)>((ref) {
  return (LoginParams params) async {
    final state = ref.read(loginStateProvider.notifier);
    state.state = const AsyncLoading();

    final result = await AsyncValue.guard(
          () => ref.read(loginUseCaseProvider).call(params),
    );

    state.state = result;
    return result.hasValue && result.value != null;
  };
});

// ---------- Register ----------

final registerStateProvider =
StateProvider.autoDispose<AsyncValue<UserEntity?>>(
      (ref) => const AsyncData(null),
);

final registerProvider =
Provider.autoDispose<Future<bool> Function(RegisterParams)>((ref) {
  return (RegisterParams params) async {
    final state = ref.read(registerStateProvider.notifier);
    state.state = const AsyncLoading();

    final result = await AsyncValue.guard(
          () => ref.read(registerUseCaseProvider).call(params),
    );

    state.state = result;
    return result.hasValue && result.value != null;
  };
});