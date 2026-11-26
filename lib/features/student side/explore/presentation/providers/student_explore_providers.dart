import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/app_exception.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/features/student%20side/explore/domain/usecases/get_course_by_id_usecase.dart';
import 'package:qatar_teachers/features/student%20side/explore/domain/usecases/get_courses_usecase.dart';
import 'package:qatar_teachers/features/student%20side/explore/domain/usecases/get_subjects_usecase.dart';
import 'package:qatar_teachers/features/student%20side/explore/domain/usecases/get_teacher_by_id_usecase.dart';
import 'package:qatar_teachers/features/student%20side/explore/domain/usecases/search_courses_usecase.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import '../../data/data source/student_explore_ds.dart';
import '../../data/repository/student_explore_repository_impl.dart';
import '../../domain/entity/teacher_profile_entity.dart';
import '../../domain/repository/student_explore_repository.dart';

// ───────────────────────── Providers ─────────────────────────

final studentExploreDsProvider = Provider<StudentExploreDs>(
      (ref) => StudentExploreDsImpl(),
);

final studentExploreRepositoryProvider = Provider<StudentExploreRepository>(
      (ref) => StudentExploreRepositoryImpl(ref.watch(studentExploreDsProvider)),
);

final getCoursesUseCaseProvider = Provider<GetCoursesUseCase>(
      (ref) => GetCoursesUseCase(ref.watch(studentExploreRepositoryProvider)),
);

final searchCoursesUseCaseProvider = Provider<SearchCoursesUseCase>(
      (ref) => SearchCoursesUseCase(ref.watch(studentExploreRepositoryProvider)),
);

final getCourseByIdUseCaseProvider = Provider<GetCourseByIdUseCase>(
      (ref) => GetCourseByIdUseCase(ref.watch(studentExploreRepositoryProvider)),
);

final getSubjectsUseCaseProvider = Provider<GetSubjectsUseCase>(
      (ref) => GetSubjectsUseCase(ref.watch(studentExploreRepositoryProvider)),
);

final getTeacherByIdUseCaseProvider = Provider<GetTeacherByIdUseCase>(
      (ref) => GetTeacherByIdUseCase(ref.watch(studentExploreRepositoryProvider)),
);

final courseDetailsProvider =
FutureProvider.autoDispose.family<StudentCourseEntity, int>(
      (ref, id) => ref.read(getCourseByIdUseCaseProvider)(id),
);

/// Not autoDispose on purpose: subjects rarely change, so they are fetched
/// once and reused every time the Explore screen opens.
final exploreSubjectsProvider = FutureProvider<List<String>>(
      (ref) => ref.read(getSubjectsUseCaseProvider)(),
);

final teacherProfileProvider =
FutureProvider.autoDispose.family<TeacherProfileEntity, int>(
      (ref, id) => ref.read(getTeacherByIdUseCaseProvider)(id),
);

// ───────────────────────── State ─────────────────────────

const _keep = Object();

class ExploreState {
  final List<StudentCourseEntity> items;
  final int page;
  final bool hasMore;
  final bool loading;
  final bool loadingMore;
  final String? error;
  final String query;
  final String? subject;

  const ExploreState({
    this.items = const [],
    this.page = 0,
    this.hasMore = true,
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.query = '',
    this.subject,
  });

  ExploreState copyWith({
    List<StudentCourseEntity>? items,
    int? page,
    bool? hasMore,
    bool? loading,
    bool? loadingMore,
    bool clearError = false,
    String? error,
    String? query,
    Object? subject = _keep,
  }) {
    return ExploreState(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: clearError ? null : (error ?? this.error),
      query: query ?? this.query,
      subject: identical(subject, _keep) ? this.subject : subject as String?,
    );
  }
}

// ───────────────────────── Notifier ─────────────────────────

class ExploreNotifier extends Notifier<ExploreState> {
  static const pageSize = 10;
  static const _debounceDuration = Duration(milliseconds: 400);

  int _token = 0;
  bool _disposed = false;
  Timer? _debounce;

  @override
  ExploreState build() {
    _disposed = false;
    ref.onDispose(() {
      _disposed = true;
      _token++; // invalidate any in-flight request
      _debounce?.cancel();
    });

    Future.microtask(() => _load(reset: true));
    return const ExploreState(loading: true);
  }

  bool _isStale(int token) => _disposed || token != _token;

  void setQuery(String value) {
    final q = value.trim();
    if (q == state.query) return;
    state = state.copyWith(query: q);

    _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () {
      if (!_disposed) _load(reset: true);
    });
  }

  void setSubject(String? subject) {
    if (subject == state.subject) return;
    _debounce?.cancel();
    state = state.copyWith(subject: subject);
    _load(reset: true);
  }

  Future<void> refresh() {
    _debounce?.cancel();
    return _load(reset: true);
  }

  Future<void> loadMore({bool retry = false}) {
    if (state.loading || state.loadingMore || !state.hasMore) {
      return Future.value();
    }
    if (state.error != null && !retry) return Future.value();
    return _load(reset: false);
  }

  Future<List<StudentCourseEntity>> _fetch(int page) {
    final keyword = state.query;
    // The search endpoint requires `keyword`, so it is used only when the
    // user has typed something.
    if (keyword.isNotEmpty) {
      return ref.read(searchCoursesUseCaseProvider)(
        keyword: keyword,
        subject: state.subject,
        page: page,
        pageSize: pageSize,
      );
    }
    return ref.read(getCoursesUseCaseProvider)(
      subject: state.subject,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<void> _load({required bool reset}) async {
    if (_disposed) return;
    final token = ++_token;

    state = reset
        ? state.copyWith(
      items: const [],
      page: 0,
      hasMore: true,
      loading: true,
      loadingMore: false,
      clearError: true,
    )
        : state.copyWith(loadingMore: true, clearError: true);

    final next = reset ? 1 : state.page + 1;

    try {
      final result = await _fetch(next);
      if (_isStale(token)) return; // disposed or replaced by a newer request

      // Drop items we already have (backend page shifts can cause duplicates).
      final seen = state.items.map((e) => e.id).toSet();
      final fresh = result.where((e) => seen.add(e.id)).toList();

      state = state.copyWith(
        items: [...state.items, ...fresh],
        page: next,
        hasMore: result.length >= pageSize, // based on raw page size
        loading: false,
        loadingMore: false,
      );
    } on AppException catch (e) {
      if (!_isStale(token)) _fail(e.message);
    } on Failure catch (f) {
      if (!_isStale(token)) _fail(f.message);
    } catch (_) {
      if (!_isStale(token)) _fail('Failed to load courses');
    }
  }

  void _fail(String message) {
    state = state.copyWith(loading: false, loadingMore: false, error: message);
  }
}

final exploreProvider =
NotifierProvider.autoDispose<ExploreNotifier, ExploreState>(
  ExploreNotifier.new,
);