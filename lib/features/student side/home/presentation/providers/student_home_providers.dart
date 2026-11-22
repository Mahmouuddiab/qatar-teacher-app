import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/data source/student_home_ds.dart';
import '../../data/repository/student_home_repository_impl.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repository/student_home_repository.dart';
import '../../domain/usecases/get_subjects_usecase.dart';
import '../../domain/entities/student_course_entity.dart';
import '../../domain/usecases/get_student_courses_usecase.dart';
import '../../domain/entities/student_booking_entity.dart';
import '../../domain/usecases/get_student_bookings_usecase.dart';

final studentHomeDsProvider = Provider<StudentHomeDs>(
      (ref) => StudentHomeDsImpl(),
);

final studentHomeRepositoryProvider = Provider<StudentHomeRepository>(
      (ref) => StudentHomeRepositoryImpl(ref.watch(studentHomeDsProvider)),
);

final getSubjectsUseCaseProvider = Provider<GetSubjectsUseCase>(
      (ref) => GetSubjectsUseCase(ref.watch(studentHomeRepositoryProvider)),
);

final subjectsProvider = FutureProvider.autoDispose<List<SubjectEntity>>(
      (ref) => ref.read(getSubjectsUseCaseProvider)(),
);

/// Selected subject name. null = "All".
class SelectedSubjectNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? name) => state = name;
}

final selectedSubjectProvider =
NotifierProvider<SelectedSubjectNotifier, String?>(
  SelectedSubjectNotifier.new,
);

final getStudentCoursesUseCaseProvider = Provider<GetStudentCoursesUseCase>(
      (ref) => GetStudentCoursesUseCase(ref.watch(studentHomeRepositoryProvider)),
);

/// Reloads automatically when the selected subject chip changes.
final latestCoursesProvider =
FutureProvider.autoDispose<List<StudentCourseEntity>>((ref) async {
  final subject = ref.watch(selectedSubjectProvider);
  final courses = await ref.read(getStudentCoursesUseCaseProvider)(
    subject: subject,
    pageSize: 10,
  );

  // Safety net in case the server ignores the subject parameter
  return courses
      .where((c) =>
  c.isActive &&
      (subject == null ||
          c.subject.toLowerCase() == subject.toLowerCase()))
      .toList();
});

final getStudentBookingsUseCaseProvider = Provider<GetStudentBookingsUseCase>(
      (ref) => GetStudentBookingsUseCase(ref.watch(studentHomeRepositoryProvider)),
);

/// Next confirmed sessions that haven't started yet, soonest first.
final upcomingSessionsProvider =
FutureProvider.autoDispose<List<StudentBookingEntity>>((ref) async {
  final bookings = await ref.read(getStudentBookingsUseCaseProvider)(
    status: 'Confirmed',
    pageSize: 3,
  );

  final now = DateTime.now();
  final upcoming = bookings
      .where((b) =>
  b.status.toLowerCase() == 'confirmed' && b.sessionDate.isAfter(now))
      .toList()
    ..sort((a, b) => a.sessionDate.compareTo(b.sessionDate));

  return upcoming.take(3).toList();
});