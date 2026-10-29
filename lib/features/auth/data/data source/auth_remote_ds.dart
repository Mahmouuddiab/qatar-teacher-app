import 'package:dio/dio.dart';
import 'package:qatar_teachers/core/cache/cache_helper.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/params/login_params.dart';
import 'package:qatar_teachers/core/params/register_params.dart';
import 'package:qatar_teachers/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDs {
  Future<UserModel> register(RegisterParams registerParams);
  Future<UserModel> login(LoginParams loginParams);
}

class AuthRemoteDSImpl implements AuthRemoteDs {
  @override
  Future<UserModel> login(LoginParams loginParams) async {
    try {
      final response = await DioHelper.post(
        path: ApiConstants.login,
        data: {"email": loginParams.email, "password": loginParams.password},
      );
      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        await CacheHelper.saveToken(user.token);
        return user;
      }
      throw ServerException(
        _messageFromData(response.data, fallback: 'Failed to login'),
      );
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(
        _messageFromData(e.response?.data,
            fallback: e.message ?? 'Network error'),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> register(RegisterParams registerParams) async {
    try {
      final response = await DioHelper.post(
        path: ApiConstants.register,
        data: {
          "fullName": registerParams.fullName,
          "email": registerParams.email,
          "phoneNumber": registerParams.phone,
          "password": registerParams.password,
          "role": registerParams.role,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      }
      throw ServerException(
        _messageFromData(response.data, fallback: 'Failed to register'),
      );
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      throw ServerException(
        _messageFromData(e.response?.data,
            fallback: e.message ?? 'Network error'),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Reads the server's message from a response body (Map or String).
  String _messageFromData(dynamic data, {required String fallback}) {
    if (data is Map) {
      final message = data['message'] ?? data['title'] ?? data['error'];
      if (message != null) return message.toString();
    }
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }
}