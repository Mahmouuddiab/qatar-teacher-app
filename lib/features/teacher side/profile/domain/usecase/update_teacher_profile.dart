import 'package:qatar_teachers/core/params/update_teacher_profile.dart';
import '../repository/teacher_profile_repository.dart';

class UpdateTeacherProfileUseCase {
  const UpdateTeacherProfileUseCase(this.repository);

  final TeacherProfileRepository repository;

  Future<void> call(UpdateTeacherProfileParams params) {
    return repository.updateTeacherProfile(params);
  }
}
