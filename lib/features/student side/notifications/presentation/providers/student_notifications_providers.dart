import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/features/teacher%20side/notifications/domain/entities/notification_entity.dart';
import '../../data/data source/student_notifications_ds.dart';
import '../../data/repository/student_notifications_repository_impl.dart';
import '../../domain/repository/student_notifications_repository.dart';
import '../../domain/usecases/get_student_notifications_usecase.dart';
import '../../domain/usecases/get_student_unread_count_usecase.dart';
import '../../domain/usecases/mark_student_notification_read_usecase.dart';
import '../../domain/usecases/mark_all_student_notifications_read_usecase.dart';

final studentNotificationsDsProvider = Provider<StudentNotificationsDs>(
  (ref) => StudentNotificationsDsImpl(),
);

final studentNotificationsRepositoryProvider =
    Provider<StudentNotificationsRepository>(
      (ref) => StudentNotificationsRepositoryImpl(
        ref.watch(studentNotificationsDsProvider),
      ),
    );

final getStudentNotificationsUseCaseProvider =
    Provider<GetStudentNotificationsUseCase>(
      (ref) => GetStudentNotificationsUseCase(
        ref.watch(studentNotificationsRepositoryProvider),
      ),
    );

/// Family key = unreadOnly
final studentNotificationsProvider = FutureProvider.autoDispose
    .family<List<NotificationEntity>, bool>(
      (ref, unreadOnly) => ref.read(getStudentNotificationsUseCaseProvider)(
        unreadOnly: unreadOnly,
      ),
    );

final getStudentUnreadCountUseCaseProvider =
    Provider<GetStudentUnreadCountUseCase>(
      (ref) => GetStudentUnreadCountUseCase(
        ref.watch(studentNotificationsRepositoryProvider),
      ),
    );

/// Not autoDispose, so the badge keeps its last value while refreshing.
final studentUnreadCountProvider = FutureProvider<int>(
  (ref) => ref.read(getStudentUnreadCountUseCaseProvider)(),
);

final markStudentNotificationReadUseCaseProvider =
    Provider<MarkStudentNotificationReadUseCase>(
      (ref) => MarkStudentNotificationReadUseCase(
        ref.watch(studentNotificationsRepositoryProvider),
      ),
    );

class StudentNotificationActionsNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// Non-critical, so it returns only a bool.
  Future<bool> markRead(int id) async {
    try {
      await ref.read(markStudentNotificationReadUseCaseProvider)(id);
      _refreshLists();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns null on success, or an error message.
  Future<String?> markAllRead() async {
    if (state) return null;
    state = true;
    try {
      await ref.read(markAllStudentNotificationsReadUseCaseProvider)();
      _refreshLists();
      return null;
    } on AppException catch (e) {
      return e.message;
    } on Failure catch (f) {
      return f.message;
    } catch (_) {
      return 'Something went wrong, please try again';
    } finally {
      state = false;
    }
  }

  void _refreshLists() {
    ref.invalidate(studentNotificationsProvider); // All and Unread
    ref.invalidate(studentUnreadCountProvider);
  }
}

final studentNotificationActionsProvider =
    NotifierProvider<StudentNotificationActionsNotifier, bool>(
      StudentNotificationActionsNotifier.new,
    );

final markAllStudentNotificationsReadUseCaseProvider =
    Provider<MarkAllStudentNotificationsReadUseCase>(
      (ref) => MarkAllStudentNotificationsReadUseCase(
        ref.watch(studentNotificationsRepositoryProvider),
      ),
    );
