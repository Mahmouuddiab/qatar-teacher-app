import 'package:qatar_teachers/core/params/login_params.dart';
import 'package:qatar_teachers/core/params/register_params.dart';
import 'package:qatar_teachers/features/auth/data/data%20source/auth_remote_ds.dart';
import 'package:qatar_teachers/features/auth/domain/entity/user_entity.dart';
import 'package:qatar_teachers/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDs remote;
  AuthRepositoryImpl(this.remote);
  @override
  Future<UserEntity> login(LoginParams loginParams) async {
    return await remote.login(loginParams);
  }

  @override
  Future<UserEntity> register(RegisterParams registerParams) async {
    return await remote.register(registerParams);
  }
}
