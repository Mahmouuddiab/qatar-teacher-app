import '../repository/student_notifications_repository.dart';

class GetStudentUnreadCountUseCase {
  final StudentNotificationsRepository _repository;
  const GetStudentUnreadCountUseCase(this._repository);

  Future<int> call() => _repository.getUnreadCount();
}