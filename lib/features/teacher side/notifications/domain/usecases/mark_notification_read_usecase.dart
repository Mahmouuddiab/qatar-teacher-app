import '../repository/teacher_notifications_repository.dart';

class MarkNotificationReadUseCase {
  final TeacherNotificationsRepository _repository;
  const MarkNotificationReadUseCase(this._repository);

  Future<void> call(int id) => _repository.markAsRead(id);
}