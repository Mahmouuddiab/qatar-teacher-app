import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import '../../data/data source/teacher_booking_ds.dart';
import '../../data/repository/teacher_booking_repo_impl.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repository/teacher_booking_repository.dart';
import '../../domain/usecases/complete_booking_usecase.dart';
import '../../domain/usecases/get_booking_details_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../../domain/usecases/respond_to_booking_usecase.dart';

final teacherBookingDsProvider = Provider<TeacherBookingDs>(
  (ref) => TeacherBookingDsImpl(),
);

final teacherBookingRepositoryProvider = Provider<TeacherBookingRepository>(
  (ref) => TeacherBookingRepositoryImpl(ref.watch(teacherBookingDsProvider)),
);

final getBookingsUseCaseProvider = Provider<GetBookingsUseCase>(
  (ref) => GetBookingsUseCase(ref.watch(teacherBookingRepositoryProvider)),
);

final bookingsProvider = FutureProvider.autoDispose<List<BookingEntity>>(
  (ref) => ref.read(getBookingsUseCaseProvider)(),
);

final getBookingDetailsUseCaseProvider = Provider<GetBookingDetailsUseCase>(
  (ref) =>
      GetBookingDetailsUseCase(ref.watch(teacherBookingRepositoryProvider)),
);

final bookingDetailsProvider = FutureProvider.autoDispose
    .family<BookingEntity, int>(
      (ref, id) => ref.read(getBookingDetailsUseCaseProvider)(id),
    );

final respondToBookingUseCaseProvider = Provider<RespondToBookingUseCase>(
  (ref) => RespondToBookingUseCase(ref.watch(teacherBookingRepositoryProvider)),
);

final completeBookingUseCaseProvider = Provider<CompleteBookingUseCase>(
  (ref) => CompleteBookingUseCase(ref.watch(teacherBookingRepositoryProvider)),
);

/// State = true while a request is running
class BookingActionNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// Returns null on success, or an error message.
  Future<String?> respond(int id, bool accept) =>
      _run(id, () => ref.read(respondToBookingUseCaseProvider)(id, accept));

  /// Returns null on success, or an error message.
  Future<String?> complete(int id) =>
      _run(id, () => ref.read(completeBookingUseCaseProvider)(id));

  Future<String?> _run(int id, Future<void> Function() action) async {
    if (state) return null;
    state = true;
    try {
      await action();
      ref.invalidate(bookingsProvider);
      ref.invalidate(bookingDetailsProvider(id));
      // Optional: keep the home dashboard counts in sync
      // ref.invalidate(dashboardProvider);
      return null;
    } on AppException catch (e) {
      return e.message; // e.g. "Session has not finished yet."
    } on Failure catch (f) {
      return f.message;
    } catch (_) {
      return 'Something went wrong, please try again';
    } finally {
      state = false;
    }
  }
}

final bookingActionProvider = NotifierProvider<BookingActionNotifier, bool>(
  BookingActionNotifier.new,
);
