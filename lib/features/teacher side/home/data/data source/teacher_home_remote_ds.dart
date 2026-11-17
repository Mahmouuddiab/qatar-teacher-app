import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/params/add_course_params.dart';
import 'package:qatar_teachers/core/params/update_course_params.dart';
import '../models/course_model.dart';

abstract class TeacherHomeRemoteDataSource {
  Future<CourseModel> addCourse(AddCourseParams params);
  Future<List<CourseModel>> getCourses();
  Future<CourseModel> getCourseDetails(int id);
  Future<CourseModel> updateCourse(UpdateCourseParams params);
  Future<void> deleteCourse(int id);
}

class TeacherHomeRemoteDataSourceImpl implements TeacherHomeRemoteDataSource {
  @override
  Future<CourseModel> addCourse(AddCourseParams params) async {
    final response = await DioHelper.post(
      path: ApiConstants.teacherCourses,
      withAuth: true,
      data: {
        'title': params.title,
        'subject': params.subject,
        'description': params.description,
        'level': params.level,
        'pricePerSessionQAR': params.pricePerSessionQAR,
        'durationMinutes': params.durationMinutes,
        'sessionMode': params.sessionMode,
      },
    );

    final data = response.data;

    if (data is Map<String, dynamic>) {
      return CourseModel.fromJson(data);
    }

    throw Exception('Invalid add course response format');
  }

  @override
  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.teacherCourses,
        withAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final List list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException();
    } catch (e) {
      debugPrint('getCourses parse error: $e');
      throw ServerException();
    }
  }

  @override
  Future<CourseModel> getCourseDetails(int id) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.teacherCourseDetails(id),
        withAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final Map<String, dynamic> json =
            data is Map<String, dynamic> && data['data'] is Map<String, dynamic>
            ? data['data'] as Map<String, dynamic>
            : data as Map<String, dynamic>;
        return CourseModel.fromJson(json);
      }

      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException {
      throw ServerException();
    } catch (e) {
      debugPrint('getCourseDetails parse error: $e');
      throw ServerException();
    }
  }

  @override
  Future<CourseModel> updateCourse(UpdateCourseParams params) async {
    try {
      final response = await DioHelper.put(
        path: ApiConstants.updateTeacherCourse(params.id),
        data: params.toJson(),
        withAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final json = data['data'] is Map<String, dynamic>
              ? data['data'] as Map<String, dynamic>
              : data;
          if (json.containsKey('id')) return CourseModel.fromJson(json);
        }
        return await getCourseDetails(params.id);
      }

      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException {
      throw ServerException();
    } catch (e) {
      debugPrint('updateCourse error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    try {
      final response = await DioHelper.delete(
        path: ApiConstants.deleteTeacherCourse(id),
        withAuth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 204) return;

      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException {
      throw ServerException();
    } catch (e) {
      debugPrint('deleteCourse error: $e');
      throw ServerException();
    }
  }
}
