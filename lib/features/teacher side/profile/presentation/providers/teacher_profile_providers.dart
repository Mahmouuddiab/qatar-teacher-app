import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/data/data%20source/teacher_profile_ds.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/data/repository/teacher_profile_repository_impl.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/domain/entity/profile_entity.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/domain/repository/teacher_profile_repository.dart';
import '../../domain/usecase/get_teacher_profile_usecase.dart';

/// 1. Remote data source provider
final teacherProfileDsProvider = Provider<TeacherProfileDs>((ref) {
  return TeacherProfileDsImpl();
});

/// 2. Repository provider
final teacherProfileRepositoryProvider =
Provider<TeacherProfileRepository>((ref) {
  final remote = ref.watch(teacherProfileDsProvider);

  return TeacherProfileRepositoryImpl(remote);
});

/// 3. Use case provider
final getTeacherProfileUseCaseProvider =
Provider<GetTeacherProfileUseCase>((ref) {
  final repository = ref.watch(teacherProfileRepositoryProvider);

  return GetTeacherProfileUseCase(repository);
});

/// 4. Teacher profile provider
final teacherProfileProvider = FutureProvider<ProfileEntity>((ref) {
  final getTeacherProfile = ref.watch(getTeacherProfileUseCaseProvider);

  return getTeacherProfile.call();
});