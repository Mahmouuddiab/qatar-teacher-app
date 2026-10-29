import 'package:qatar_teachers/core/params/login_params.dart';
import 'package:qatar_teachers/features/auth/domain/entity/user_entity.dart';
import 'package:qatar_teachers/features/auth/domain/repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repo;
  LoginUseCase(this.repo);
  Future<UserEntity> call(LoginParams loginParams)=> repo.login(loginParams);
}