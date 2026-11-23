import '../../../../teacher side/notifications/domain/entities/notification_entity.dart';

abstract class StudentNotificationsRepository {
  Future<List<NotificationEntity>> getNotifications({
    bool unreadOnly = false,
    int page = 1,
    int pageSize = 30,
  });
  Future<int> getUnreadCount();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
}