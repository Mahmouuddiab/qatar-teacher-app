import '../entities/notification_entity.dart';
import '../repository/teacher_notifications_repository.dart';

class GetNotificationsUseCase {
  final TeacherNotificationsRepository _repository;
  const GetNotificationsUseCase(this._repository);

  Future<List<NotificationEntity>> call({
    bool unreadOnly = false,
    int page = 1,
    int pageSize = 30,
  }) =>
      _repository.getNotifications(
        unreadOnly: unreadOnly,
        page: page,
        pageSize: pageSize,
      );
}