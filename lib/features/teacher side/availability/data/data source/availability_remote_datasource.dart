import 'package:dio/dio.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import '../models/availability_model.dart';

abstract class TeacherAvailabilityDs {
  Future<AvailabilityModel> addAvailability(AvailabilityModel model);
  Future<List<AvailabilityModel>> getAvailabilities();
  Future<void> deleteAvailability(int id);
}

class TeacherAvailabilityDsImpl implements TeacherAvailabilityDs {
  @override
  Future<AvailabilityModel> addAvailability(AvailabilityModel model) async {
    try {
      final response = await DioHelper.post(
        path: ApiConstants.teacherAvailability,
        data: model.toJson(),
        withAuth: true,
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return AvailabilityModel.fromJson(data);
      }

      throw Exception('Invalid availability response format.');
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to add availability.'));
    }
  }

  @override
  Future<List<AvailabilityModel>> getAvailabilities() async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.teacherAvailability,
        withAuth: true,
      );

      final data = response.data;
      final list = data is List
          ? data
          : (data is Map && data['data'] is List ? data['data'] as List : null);

      if (list == null) {
        throw Exception('Invalid availability response format.');
      }

      return list
          .whereType<Map<String, dynamic>>()
          .map(AvailabilityModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to load availability.'));
    }
  }

  @override
  Future<void> deleteAvailability(int id) async {
    try {
      await DioHelper.delete(
        path: ApiConstants.teacherAvailabilityById(id),
        withAuth: true,
      );
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to delete availability.'));
    }
  }

  String _errorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    final message = data is Map ? data['message']?.toString() : null;
    return message ?? e.message ?? fallback;
  }
}
