import '../repository/student_notifications_repository.dart';

class MarkAllStudentNotificationsReadUseCase {
  final StudentNotificationsRepository _repository;
  const MarkAllStudentNotificationsReadUseCase(this._repository);

  Future<void> call() => _repository.markAllAsRead();
}