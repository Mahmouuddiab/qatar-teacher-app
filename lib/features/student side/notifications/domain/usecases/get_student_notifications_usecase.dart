import '../../../../teacher side/notifications/domain/entities/notification_entity.dart';
import '../repository/student_notifications_repository.dart';

class GetStudentNotificationsUseCase {
  final StudentNotificationsRepository _repository;
  const GetStudentNotificationsUseCase(this._repository);

  Future<List<NotificationEntity>> call({
    bool unreadOnly = false,
    int page = 1,
    int pageSize = 30,
  }) => _repository.getNotifications(
    unreadOnly: unreadOnly,
    page: page,
    pageSize: pageSize,
  );
}
