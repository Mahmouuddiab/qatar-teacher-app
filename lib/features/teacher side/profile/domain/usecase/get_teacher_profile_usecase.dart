import 'package:qatar_teachers/features/teacher%20side/profile/domain/repository/teacher_profile_repository.dart';
import '../entity/profile_entity.dart';

class GetTeacherProfileUseCase {
  final TeacherProfileRepository repo;
  GetTeacherProfileUseCase(this.repo);
  Future<ProfileEntity> call(String id)=> repo.getTeacherProfile(id);
}