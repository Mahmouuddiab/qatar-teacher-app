import '../entities/notification_entity.dart';

abstract class TeacherNotificationsRepository {
  Future<List<NotificationEntity>> getNotifications({
    bool unreadOnly = false,
    int page = 1,
    int pageSize = 30,
  });
  Future<int> getUnreadCount();
  Future<void> markAsRead(int id);
}