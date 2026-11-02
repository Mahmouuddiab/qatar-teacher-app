import 'package:qatar_teachers/core/params/update_teacher_profile.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/domain/entity/profile_entity.dart';

abstract class TeacherProfileRepository {
  Future<ProfileEntity> getTeacherProfile();
  Future<void> updateTeacherProfile(UpdateTeacherProfileParams params);
}