import 'package:qatar_teachers/features/teacher%20side/profile/data/data%20source/teacher_profile_ds.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/domain/entity/profile_entity.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/domain/repository/teacher_profile_repository.dart';

class TeacherProfileRepositoryImpl implements TeacherProfileRepository {
  final TeacherProfileDs remote;
  TeacherProfileRepositoryImpl(this.remote);
  @override
  Future<ProfileEntity> getTeacherProfile(String id) async{
    return await remote.getTeacherProfile(id) ;
  }
  
}