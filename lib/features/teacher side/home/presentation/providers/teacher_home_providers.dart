import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/params/add_course_params.dart';
import '../../data/data source/teacher_home_remote_ds.dart';
import '../../data/repository/teacher_home_repository_impl.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repository/teacher_home_repository.dart';
import '../../domain/usecases/add_course_usecase.dart';

final teacherHomeRemoteDataSourceProvider =
    Provider<TeacherHomeRemoteDataSource>(
      (ref) => TeacherHomeRemoteDataSourceImpl(),
    );

final teacherHomeRepositoryProvider = Provider<TeacherHomeRepository>(
  (ref) =>
      TeacherHomeRepositoryImpl(ref.watch(teacherHomeRemoteDataSourceProvider)),
);

final addCourseUseCaseProvider = Provider<AddCourseUseCase>(
  (ref) => AddCourseUseCase(ref.watch(teacherHomeRepositoryProvider)),
);

enum AddCourseStatus { initial, loading, success, failure }

class AddCourseState {
  final AddCourseStatus status;
  final CourseEntity? course;
  final String? errorMessage;

  const AddCourseState({
    this.status = AddCourseStatus.initial,
    this.course,
    this.errorMessage,
  });

  bool get isLoading => status == AddCourseStatus.loading;
}

class AddCourseNotifier extends Notifier<AddCourseState> {
  @override
  AddCourseState build() => const AddCourseState();

  Future<void> addCourse(AddCourseParams params) async {
    if (state.isLoading) return;
    state = const AddCourseState(status: AddCourseStatus.loading);

    try {
      final course = await ref.read(addCourseUseCaseProvider)(params);
      state = AddCourseState(status: AddCourseStatus.success, course: course);
    } on Failure catch (f) {
      state = AddCourseState(
        status: AddCourseStatus.failure,
        errorMessage: f.message,
      );
    } catch (_) {
      state = const AddCourseState(
        status: AddCourseStatus.failure,
        errorMessage: 'Something went wrong, please try again',
      );
    }
  }

  void reset() => state = const AddCourseState();
}

final addCourseProvider =
    NotifierProvider.autoDispose<AddCourseNotifier, AddCourseState>(
      AddCourseNotifier.new,
    );
