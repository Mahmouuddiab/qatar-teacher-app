import '../repository/student_notifications_repository.dart';

class MarkStudentNotificationReadUseCase {
  final StudentNotificationsRepository _repository;
  const MarkStudentNotificationReadUseCase(this._repository);

  Future<void> call(int id) => _repository.markAsRead(id);
}