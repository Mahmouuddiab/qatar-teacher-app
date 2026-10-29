import 'package:qatar_teachers/core/params/login_params.dart';
import 'package:qatar_teachers/core/params/register_params.dart';
import 'package:qatar_teachers/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> register(RegisterParams registerParams);
  Future<UserEntity> login(LoginParams loginParams);
}