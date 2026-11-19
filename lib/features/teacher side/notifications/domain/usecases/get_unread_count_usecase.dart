import '../repository/teacher_notifications_repository.dart';

class GetUnreadCountUseCase {
  final TeacherNotificationsRepository _repository;
  const GetUnreadCountUseCase(this._repository);

  Future<int> call() => _repository.getUnreadCount();
}