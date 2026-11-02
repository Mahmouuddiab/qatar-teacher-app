import 'package:dio/dio.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/params/update_teacher_profile.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/data/models/profile_model.dart';

abstract class TeacherProfileDs {
  Future<ProfileModel> getTeacherProfile();
  Future<void> updateTeacherProfile(UpdateTeacherProfileParams params);
}

class TeacherProfileDsImpl implements TeacherProfileDs {
  @override
  Future<ProfileModel> getTeacherProfile() async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.teacherProfile,
        withAuth: true,
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return ProfileModel.fromJson(data);
      }

      throw Exception('Invalid teacher profile response format.');
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : null;

      throw Exception(
        message ?? e.message ?? 'Failed to load teacher profile.',
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTeacherProfile(UpdateTeacherProfileParams params) async {
    try {
      await DioHelper.put(
        path: ApiConstants.teacherProfile,
        data: params.toJson(),
        withAuth: true,
      );
    } on DioException catch (e) {
      throw Exception(_errorMessage(e, 'Failed to update teacher profile.'));
    }
  }

  String _errorMessage(DioException e, String fallback) {
    final data = e.response?.data;
    final message = data is Map ? data['message']?.toString() : null;
    return message ?? e.message ?? fallback;
  }
}
