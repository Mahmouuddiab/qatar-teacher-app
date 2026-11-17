import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:qatar_teachers/core/cache/cache_helper.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/params/change_password_params.dart';
import 'package:qatar_teachers/core/params/login_params.dart';
import 'package:qatar_teachers/core/params/register_params.dart';
import 'package:qatar_teachers/features/auth/data/data%20source/auth_remote_ds.dart';
import 'package:qatar_teachers/features/auth/data/repository/auth_repository_impl.dart';
import 'package:qatar_teachers/features/auth/domain/entity/user_entity.dart';
import 'package:qatar_teachers/features/auth/domain/repository/auth_repository.dart';
import 'package:qatar_teachers/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:qatar_teachers/features/auth/domain/usecase/login_usecase.dart';
import 'package:qatar_teachers/features/auth/domain/usecase/logout_usecase.dart';
import 'package:qatar_teachers/features/auth/domain/usecase/register_usecase.dart';

final authRemoteDsProvider = Provider<AuthRemoteDs>((ref) {
  return AuthRemoteDSImpl();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDsProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final changePasswordUseCaseProvider = Provider<ChangePasswordUseCase>(
  (ref) => ChangePasswordUseCase(ref.watch(authRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.watch(authRepositoryProvider)),
);

/// ---------- Login ----------

/// Login state: AsyncData(null) = idle, AsyncLoading, AsyncData(user), AsyncError.
final loginStateProvider = StateProvider.autoDispose<AsyncValue<UserEntity?>>(
  (ref) => const AsyncData(null),
);

/// Call it like a function: `ref.read(loginProvider)(params)`.
/// Returns true on success.
final loginProvider = Provider.autoDispose<Future<bool> Function(LoginParams)>((
  ref,
) {
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

/// ---------- Register ----------

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

/// ───────────── Change password ─────────────

enum ChangePasswordStatus { initial, loading, success, failure }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final String? errorMessage;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == ChangePasswordStatus.loading;
}

class ChangePasswordNotifier extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() => const ChangePasswordState();

  Future<void> changePassword(ChangePasswordParams params) async {
    if (state.isLoading) return;
    state = const ChangePasswordState(status: ChangePasswordStatus.loading);

    try {
      await ref.read(changePasswordUseCaseProvider)(params);
      state = const ChangePasswordState(status: ChangePasswordStatus.success);
    } on Failure catch (f) {
      state = ChangePasswordState(
        status: ChangePasswordStatus.failure,
        errorMessage: f.message,
      );
    } catch (_) {
      state = const ChangePasswordState(
        status: ChangePasswordStatus.failure,
        errorMessage: 'Something went wrong, please try again',
      );
    }
  }

  void reset() => state = const ChangePasswordState();
}

final changePasswordProvider =
    NotifierProvider.autoDispose<ChangePasswordNotifier, ChangePasswordState>(
      ChangePasswordNotifier.new,
    );

/// ───────────── Logout ─────────────

enum LogoutStatus { initial, loading, success }

class LogoutNotifier extends Notifier<LogoutStatus> {
  @override
  LogoutStatus build() => LogoutStatus.initial;

  Future<void> logout() async {
    if (state == LogoutStatus.loading) return;
    state = LogoutStatus.loading;

    try {
      await ref.read(logoutUseCaseProvider)();
    } catch (_) {
    }

    // TODO: replace with your own token/session clearing
    await CacheHelper.clearToken();

    state = LogoutStatus.success;
  }
}

final logoutProvider =
    NotifierProvider.autoDispose<LogoutNotifier, LogoutStatus>(
      LogoutNotifier.new,
    );
