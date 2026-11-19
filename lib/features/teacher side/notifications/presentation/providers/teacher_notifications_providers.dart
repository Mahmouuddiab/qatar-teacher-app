import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data source/teacher_notifications_ds.dart';
import '../../data/repository/teacher_notifications_repository_impl.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repository/teacher_notifications_repository.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
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

class NotificationActionsNotifier extends Notifier<void> {
  @override
  void build() {}

  /// Marks one notification as read, then refreshes the list and the badge.
  /// Returns false on failure. This is non-critical, so no snackbar is needed.
  Future<bool> markRead(int id) async {
    try {
      await ref.read(markNotificationReadUseCaseProvider)(id);
      ref.invalidate(notificationsProvider); // invalidates All and Unread
      ref.invalidate(unreadCountProvider);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final notificationActionsProvider =
    NotifierProvider<NotificationActionsNotifier, void>(
      NotificationActionsNotifier.new,
    );
