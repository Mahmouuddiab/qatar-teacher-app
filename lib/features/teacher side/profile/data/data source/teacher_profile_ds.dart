import 'package:dio/dio.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/data/models/profile_model.dart';

abstract class TeacherProfileDs {
  Future<ProfileModel> getTeacherProfile(String id);
}

class TeacherProfileDsImpl implements TeacherProfileDs {
  @override
  Future<ProfileModel> getTeacherProfile(String id) async {
    try {
      final response = await DioHelper.get(
        path: ApiConstants.teacherProfile(id),
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
}
