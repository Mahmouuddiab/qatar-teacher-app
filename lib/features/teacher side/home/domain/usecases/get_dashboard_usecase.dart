import '../entities/dashboard_entity.dart';
import '../repository/teacher_home_repository.dart';

class GetDashboardUseCase {
  final TeacherHomeRepository repository;
  const GetDashboardUseCase(this.repository);

  Future<DashboardEntity> call() => repository.getDashboard();
}