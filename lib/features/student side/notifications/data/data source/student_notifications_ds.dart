import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/network/error_message.dart';
import 'package:qatar_teachers/features/teacher%20side/notifications/data/models/notification_model.dart';

abstract class StudentNotificationsDs {
  Future<List<NotificationModel>> getNotifications({
    required bool unreadOnly,
    required int page,
    required int pageSize,
  });
  Future<int> getUnreadCount();
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
}

class StudentNotificationsDsImpl implements StudentNotificationsDs {
  @override
  Future<List<NotificationModel>> getNotifications({
    required bool unreadOnly,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentNotifications,
        query: {
          'unreadOnly': unreadOnly,
          'page': page,
          'pageSize': pageSize,
        },
        withAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('student getNotifications error: $e');
      throw ServerException();
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentNotificationsUnreadCount,
        withAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final count = data is Map ? data['count'] : data;
        return (count as num?)?.toInt() ?? 0;
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('student getUnreadCount error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      final response = await DioHelper.put(
        path: ApiConstants.studentNotificationRead(id),
        withAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 204) return;
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('student markAsRead error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      final response = await DioHelper.put(
        path: ApiConstants.studentNotificationsReadAll,
        withAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 204) return;
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('student markAllAsRead error: $e');
      throw ServerException();
    }
  }
}