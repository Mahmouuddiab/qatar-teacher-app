import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/params/add_course_params.dart';
import 'package:qatar_teachers/core/params/update_course_params.dart';
import '../../data/data source/teacher_home_remote_ds.dart';
import '../../data/repository/teacher_home_repository_impl.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repository/teacher_home_repository.dart';
import '../../domain/usecases/add_course_usecase.dart';
import '../../domain/usecases/delete_course_usecase.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/update_course_usecase.dart';

/// ───────────── Dependencies ─────────────

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

final getCoursesUseCaseProvider = Provider<GetCoursesUseCase>(
  (ref) => GetCoursesUseCase(ref.watch(teacherHomeRepositoryProvider)),
);

final getCourseDetailsUseCaseProvider = Provider<GetCourseDetailsUseCase>(
  (ref) => GetCourseDetailsUseCase(ref.watch(teacherHomeRepositoryProvider)),
);

final courseDetailsProvider = FutureProvider.autoDispose
    .family<CourseEntity, int>(
      (ref, id) => ref.read(getCourseDetailsUseCaseProvider)(id),
    );

final updateCourseUseCaseProvider = Provider<UpdateCourseUseCase>(
  (ref) => UpdateCourseUseCase(ref.watch(teacherHomeRepositoryProvider)),
);

final deleteCourseUseCaseProvider = Provider<DeleteCourseUseCase>(
  (ref) => DeleteCourseUseCase(ref.watch(teacherHomeRepositoryProvider)),
);

/// ───────────── Get courses ─────────────

class CoursesNotifier extends AsyncNotifier<List<CourseEntity>> {
  @override
  Future<List<CourseEntity>> build() => ref.read(getCoursesUseCaseProvider)();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(getCoursesUseCaseProvider)());
  }
}

final coursesProvider =
    AsyncNotifierProvider.autoDispose<CoursesNotifier, List<CourseEntity>>(
      CoursesNotifier.new,
    );

/// ───────────── Add course ─────────────

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
      ref.invalidate(coursesProvider); // refresh the list after adding
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

/// ───────────── update  courses ─────────────

enum UpdateCourseStatus { initial, loading, success, failure }

class UpdateCourseState {
  final UpdateCourseStatus status;
  final CourseEntity? course;
  final String? errorMessage;

  const UpdateCourseState({
    this.status = UpdateCourseStatus.initial,
    this.course,
    this.errorMessage,
  });

  bool get isLoading => status == UpdateCourseStatus.loading;
}

class UpdateCourseNotifier extends Notifier<UpdateCourseState> {
  @override
  UpdateCourseState build() => const UpdateCourseState();

  Future<void> updateCourse(UpdateCourseParams params) async {
    if (state.isLoading) return;
    state = const UpdateCourseState(status: UpdateCourseStatus.loading);

    try {
      final course = await ref.read(updateCourseUseCaseProvider)(params);
      state = UpdateCourseState(
        status: UpdateCourseStatus.success,
        course: course,
      );
      // Refresh both the list and the details screen
      ref.invalidate(coursesProvider);
      ref.invalidate(courseDetailsProvider(params.id));
    } on Failure catch (f) {
      state = UpdateCourseState(
        status: UpdateCourseStatus.failure,
        errorMessage: f.message,
      );
    } catch (_) {
      state = const UpdateCourseState(
        status: UpdateCourseStatus.failure,
        errorMessage: 'Something went wrong, please try again',
      );
    }
  }

  void reset() => state = const UpdateCourseState();
}

final updateCourseProvider =
    NotifierProvider.autoDispose<UpdateCourseNotifier, UpdateCourseState>(
      UpdateCourseNotifier.new,
    );

/// ───────────── delete  courses ─────────────

enum DeleteCourseStatus { initial, loading, success, failure }

class DeleteCourseState {
  final DeleteCourseStatus status;
  final String? errorMessage;

  const DeleteCourseState({
    this.status = DeleteCourseStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == DeleteCourseStatus.loading;
}

class DeleteCourseNotifier extends Notifier<DeleteCourseState> {
  @override
  DeleteCourseState build() => const DeleteCourseState();

  Future<void> deleteCourse(int id) async {
    if (state.isLoading) return;
    state = const DeleteCourseState(status: DeleteCourseStatus.loading);

    try {
      await ref.read(deleteCourseUseCaseProvider)(id);
      state = const DeleteCourseState(status: DeleteCourseStatus.success);
      ref.invalidate(coursesProvider); // refresh home + all courses lists
    } on Failure catch (f) {
      state = DeleteCourseState(
        status: DeleteCourseStatus.failure,
        errorMessage: f.message,
      );
    } catch (_) {
      state = const DeleteCourseState(
        status: DeleteCourseStatus.failure,
        errorMessage: 'Something went wrong, please try again',
      );
    }
  }

  void reset() => state = const DeleteCourseState();
}

final deleteCourseProvider =
    NotifierProvider.autoDispose<DeleteCourseNotifier, DeleteCourseState>(
      DeleteCourseNotifier.new,
    );
