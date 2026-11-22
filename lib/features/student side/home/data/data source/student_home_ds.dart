import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/network/error_message.dart';
import '../models/student_booking_model.dart';
import '../models/student_course_model.dart';
import '../models/subject_model.dart';

abstract class StudentHomeDs {
  Future<List<SubjectModel>> getSubjects();
  Future<List<StudentCourseModel>> getCourses({
    String? subject,
    required int pageSize,
  });
  Future<List<StudentBookingModel>> getBookings({
    String? status,
    required int pageSize,
  });
}

class StudentHomeDsImpl implements StudentHomeDs {
  @override
  Future<List<SubjectModel>> getSubjects() async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentSubjects,
        withAuth: false,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List list = data is List ? data : (data['data'] as List);
        return list
            .map(SubjectModel.fromJson)
            .where((s) => s.name.isNotEmpty)
            .toList();
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('getSubjects error: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<StudentCourseModel>> getCourses({
    String? subject,
    required int pageSize,
  }) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentCourses,
        query: {'pageSize': pageSize, if (subject != null) 'subject': subject},
        withAuth: false,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => StudentCourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('getCourses error: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<StudentBookingModel>> getBookings({
    String? status,
    required int pageSize,
  }) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentBookings,
        query: {'pageSize': pageSize, if (status != null) 'status': status},
        withAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => StudentBookingModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('getBookings error: $e');
      throw ServerException();
    }
  }
}
