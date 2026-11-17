import 'package:qatar_teachers/features/auth/domain/repository/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;
  const LogoutUseCase(this.repository);

  Future<void> call() => repository.logout();
}