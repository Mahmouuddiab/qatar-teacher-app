import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import '../../data/data source/teacher_notifications_ds.dart';
import '../../data/repository/teacher_notifications_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repository/teacher_notifications_repository.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';

final teacherNotificationsDsProvider = Provider<TeacherNotificationsDs>(
  (ref) => TeacherNotificationsDsImpl(),
);

final teacherNotificationsRepositoryProvider =
    Provider<TeacherNotificationsRepository>(
      (ref) => TeacherNotificationsRepositoryImpl(
        ref.watch(teacherNotificationsDsProvider),
      ),
    );

final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>(
  (ref) => GetNotificationsUseCase(
    ref.watch(teacherNotificationsRepositoryProvider),
  ),
);

/// Family key = unreadOnly
final notificationsProvider = FutureProvider.autoDispose
    .family<List<NotificationEntity>, bool>(
      (ref, unreadOnly) =>
          ref.read(getNotificationsUseCaseProvider)(unreadOnly: unreadOnly),
    );

final getUnreadCountUseCaseProvider = Provider<GetUnreadCountUseCase>(
  (ref) =>
      GetUnreadCountUseCase(ref.watch(teacherNotificationsRepositoryProvider)),
);

/// Not autoDispose: the home screen's bell keeps showing the last value
/// while it refreshes, instead of flickering.
final unreadCountProvider = FutureProvider<int>(
  (ref) => ref.read(getUnreadCountUseCaseProvider)(),
);

final markNotificationReadUseCaseProvider =
    Provider<MarkNotificationReadUseCase>(
      (ref) => MarkNotificationReadUseCase(
        ref.watch(teacherNotificationsRepositoryProvider),
      ),
    );

final markAllNotificationsReadUseCaseProvider =
    Provider<MarkAllNotificationsReadUseCase>(
      (ref) => MarkAllNotificationsReadUseCase(
        ref.watch(teacherNotificationsRepositoryProvider),
      ),
    );

class NotificationActionsNotifier extends Notifier<bool> {
  /// State = true while "mark all" is running
  @override
  bool build() => false;

  /// Marks one notification as read. Non-critical, so it returns only a bool.
  Future<bool> markRead(int id) async {
    try {
      await ref.read(markNotificationReadUseCaseProvider)(id);
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
      await ref.read(markAllNotificationsReadUseCaseProvider)();
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
    ref.invalidate(notificationsProvider); // All and Unread
    ref.invalidate(unreadCountProvider);
  }
}

final notificationActionsProvider =
    NotifierProvider<NotificationActionsNotifier, bool>(
      NotificationActionsNotifier.new,
    );
