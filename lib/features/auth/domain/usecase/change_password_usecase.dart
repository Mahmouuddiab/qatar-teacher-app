import 'package:qatar_teachers/core/params/change_password_params.dart';
import 'package:qatar_teachers/features/auth/domain/repository/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;
  const ChangePasswordUseCase(this.repository);

  Future<void> call(ChangePasswordParams params) =>
      repository.changePassword(params);
}