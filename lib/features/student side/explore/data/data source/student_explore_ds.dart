import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/network/error_message.dart';
import 'package:qatar_teachers/features/student%20side/home/data/models/student_course_model.dart';

import '../model/teacher_profile_model.dart';

abstract class StudentExploreDs {
  Future<List<StudentCourseModel>> getCourses({
    String? subject,
    int? teacherId,
    String? search,
    required int page,
    required int pageSize,
  });
  Future<StudentCourseModel> getCourseById(int id);
  Future<List<String>> getSubjects();
  Future<TeacherProfileModel> getTeacherById(int id);
  Future<List<StudentCourseModel>> searchCourses({
    required String keyword,
    String? subject,
    required int page,
    required int pageSize,
  });
}

class StudentExploreDsImpl implements StudentExploreDs {
  @override
  Future<List<StudentCourseModel>> getCourses({
    String? subject,
    int? teacherId,
    String? search,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentCourses,
        query: {
          'page': page,
          'pageSize': pageSize,
          if (subject != null) 'subject': subject,
          if (teacherId != null) 'teacherId': teacherId,
          if (search != null && search.isNotEmpty) 'search': search,
        },
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
      debugPrint('explore getCourses error: $e');
      throw ServerException();
    }
  }

  @override
  Future<StudentCourseModel> getCourseById(int id) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentCourseById(id),
        withAuth: false,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        // Works for both a bare object and a { "data": {...} } wrapper.
        final json = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;
        return StudentCourseModel.fromJson(json);
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('explore getCourseById error: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<String>> getSubjects() async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentSubjects,
        withAuth: false,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List list = data is List ? data : (data['data'] as List);
        return list.map((e) => e.toString()).toList();
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('explore getSubjects error: $e');
      throw ServerException();
    }
  }

  @override
  Future<TeacherProfileModel> getTeacherById(int id) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentTeacherById(id),
        withAuth: false, // public endpoint
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final json = data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data;
        return TeacherProfileModel.fromJson(json);
      }
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('explore getTeacherById error: $e');
      throw ServerException();
    }
  }

  @override
  Future<List<StudentCourseModel>> searchCourses({
    required String keyword,
    String? subject,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.studentCoursesSearch,
        query: {
          'keyword': keyword,
          'page': page,
          'pageSize': pageSize,
          if (subject != null) 'subject': subject,
        },
        withAuth: false,
      );

      if (response.statusCode == 200) return _parseCourses(response.data);
      throw ServerException(messageFromResponse(response));
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(messageFromDio(e));
    } catch (e) {
      debugPrint('explore searchCourses error: $e');
      throw ServerException();
    }
  }
  List<StudentCourseModel> _parseCourses(dynamic data) {
    final List list = data is List ? data : (data['data'] as List);
    return list
        .map((e) => StudentCourseModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
