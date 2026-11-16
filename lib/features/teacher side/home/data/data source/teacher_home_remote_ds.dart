import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/params/add_course_params.dart';

import '../models/course_model.dart';

abstract class TeacherHomeRemoteDataSource {
  Future<CourseModel> addCourse(AddCourseParams params);
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
}
