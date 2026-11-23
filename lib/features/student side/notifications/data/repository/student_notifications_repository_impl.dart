import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import '../../../../teacher side/notifications/domain/entities/notification_entity.dart';
import '../../domain/repository/student_notifications_repository.dart';
import '../data source/student_notifications_ds.dart';

class StudentNotificationsRepositoryImpl
    implements StudentNotificationsRepository {
  final StudentNotificationsDs _remote;
  const StudentNotificationsRepositoryImpl(this._remote);

  @override
  Future<List<NotificationEntity>> getNotifications({
    bool unreadOnly = false,
    int page = 1,
    int pageSize = 30,
  }) async {
    try {
      return await _remote.getNotifications(
        unreadOnly: unreadOnly,
        page: page,
        pageSize: pageSize,
      );
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      return await _remote.getUnreadCount();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      await _remote.markAsRead(id);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _remote.markAllAsRead();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    }
  }
}
