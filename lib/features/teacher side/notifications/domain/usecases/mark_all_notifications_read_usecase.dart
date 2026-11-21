import '../repository/teacher_notifications_repository.dart';

class MarkAllNotificationsReadUseCase {
  final TeacherNotificationsRepository _repository;
  const MarkAllNotificationsReadUseCase(this._repository);

  Future<void> call() => _repository.markAllAsRead();
}