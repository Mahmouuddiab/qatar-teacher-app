import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qatar_teachers/core/cache/cache_helper.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/params/change_password_params.dart';
import 'package:qatar_teachers/core/params/login_params.dart';
import 'package:qatar_teachers/core/params/register_params.dart';
import 'package:qatar_teachers/features/auth/data/model/user_model.dart';

abstract class AuthRemoteDs {
  Future<UserModel> register(RegisterParams registerParams);
  Future<UserModel> login(LoginParams loginParams);
  Future<void> changePassword(ChangePasswordParams params);
  Future<void> logout();
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
        _messageFromData(
          e.response?.data,
          fallback: e.message ?? 'Network error',
        ),
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
        _messageFromData(
          e.response?.data,
          fallback: e.message ?? 'Network error',
        ),
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  String _messageFromData(dynamic data, {required String fallback}) {
    if (data is Map) {
      final message = data['message'] ?? data['title'] ?? data['error'];
      if (message != null) return message.toString();
    }
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }

  @override
  Future<void> changePassword(ChangePasswordParams params) async {
    try {
      final response = await DioHelper.post(
        path: ApiConstants.changePassword,
        data: params.toJson(),
        withAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 204) return;
      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      // 400 usually means the current password is wrong
      final msg = e.response?.data is Map
          ? e.response?.data['message'] as String?
          : null;
      throw ServerException(/* message: msg */);
    } catch (e) {
      debugPrint('changePassword error: $e');
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await DioHelper.post(
        path: ApiConstants.logout,
        withAuth: true,
      );
      if (response.statusCode == 200 || response.statusCode == 204) return;
      throw ServerException();
    } on ServerException {
      rethrow;
    } on DioException {
      throw ServerException();
    } catch (e) {
      debugPrint('logout error: $e');
      throw ServerException();
    }
  }
}
