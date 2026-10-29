import 'package:qatar_teachers/core/params/register_params.dart';
import 'package:qatar_teachers/features/auth/domain/entity/user_entity.dart';
import 'package:qatar_teachers/features/auth/domain/repository/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repo;
  RegisterUseCase(this.repo);
  Future<UserEntity> call(RegisterParams registerParams) =>
      repo.register(registerParams);
}
