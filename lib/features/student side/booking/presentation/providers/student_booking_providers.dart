import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/params/create_booking_params.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';
import 'package:qatar_teachers/features/student%20side/home/presentation/providers/student_home_providers.dart';
import '../../data/data source/student_booking_ds.dart';
import '../../data/repository/student_booking_repository_impl.dart';
import '../../domain/repository/student_booking_repository.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';

final studentBookingDsProvider = Provider<StudentBookingDs>(
  (ref) => StudentBookingDsImpl(),
);

final studentBookingRepositoryProvider = Provider<StudentBookingRepository>(
  (ref) => StudentBookingRepositoryImpl(ref.watch(studentBookingDsProvider)),
);

final createBookingUseCaseProvider = Provider<CreateBookingUseCase>(
  (ref) => CreateBookingUseCase(ref.watch(studentBookingRepositoryProvider)),
);

final getMyBookingsUseCaseProvider = Provider<GetMyBookingsUseCase>(
  (ref) => GetMyBookingsUseCase(ref.watch(studentBookingRepositoryProvider)),
);

/// State = true while the request runs.
class CreateBookingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// Returns the created booking, or an error message (never both).
  Future<({StudentBookingEntity? booking, String? error})> create(
    CreateBookingParams params,
  ) async {
    if (state) return (booking: null, error: null);
    state = true;
    try {
      final booking = await ref.read(createBookingUseCaseProvider)(params);
      ref.invalidate(upcomingSessionsProvider);
      return (booking: booking, error: null);
    } on AppException catch (e) {
      return (booking: null, error: e.message);
    } on Failure catch (f) {
      return (booking: null, error: f.message);
    } catch (_) {
      return (booking: null, error: 'Something went wrong, please try again');
    } finally {
      state = false;
    }
  }
}

final createBookingProvider = NotifierProvider<CreateBookingNotifier, bool>(
  CreateBookingNotifier.new,
);

/// All my bookings, newest session first. Filtering happens in the screen.
final myBookingsProvider =
    FutureProvider.autoDispose<List<StudentBookingEntity>>((ref) async {
      final list = await ref.read(getMyBookingsUseCaseProvider)(pageSize: 100);
      return [...list]..sort((a, b) => b.sessionDate.compareTo(a.sessionDate));
    });

final cancelBookingUseCaseProvider = Provider<CancelBookingUseCase>(
  (ref) => CancelBookingUseCase(ref.watch(studentBookingRepositoryProvider)),
);

/// State = ids of the bookings being cancelled right now.
class CancelBookingNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() => {};

  /// Returns null on success, or an error message.
  Future<String?> cancel(int id) async {
    if (state.contains(id)) return null;
    state = {...state, id};
    try {
      await ref.read(cancelBookingUseCaseProvider)(id);
      ref.invalidate(myBookingsProvider);
      ref.invalidate(upcomingSessionsProvider);
      return null;
    } on AppException catch (e) {
      return e.message;
    } on Failure catch (f) {
      return f.message;
    } catch (_) {
      return 'Something went wrong, please try again';
    } finally {
      state = {...state}..remove(id);
    }
  }
}

final cancelBookingProvider = NotifierProvider<CancelBookingNotifier, Set<int>>(
  CancelBookingNotifier.new,
);
