import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import 'package:qatar_teachers/features/student%20side/home/presentation/widgets/student_course_card.dart';
import '../providers/student_explore_providers.dart';
import '../widgets/explore_empty_view.dart';
import '../widgets/explore_list_footer.dart';
import '../widgets/explore_search_ba.dart';
import '../widgets/explore_subject_chips.dart';
import 'student_course_details_screen.dart';

class StudentExploreScreen extends ConsumerStatefulWidget {
  const StudentExploreScreen({super.key});

  @override
  ConsumerState<StudentExploreScreen> createState() =>
      _StudentExploreScreenState();
}

class _StudentExploreScreenState extends ConsumerState<StudentExploreScreen> {
  // Space for the floating bottom nav bar
  static const double _bottomSpace = 120;

  final _scroll = ScrollController();

  // Prevents queuing more than one post-frame check at a time.
  bool _checkScheduled = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 300) {
      ref.read(exploreProvider.notifier).loadMore();
    }
  }

  /// If the loaded items don't fill the screen, the list can't scroll,
  /// so _onScroll never fires. This loads the next page in that case.
  void _loadMoreIfNotScrollable() {
    if (_checkScheduled) return;
    _checkScheduled = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScheduled = false;
      if (!mounted || !_scroll.hasClients) return;
      final s = ref.read(exploreProvider);
      final canLoad =
          s.hasMore && !s.loading && !s.loadingMore && s.error == null;
      if (canLoad && _scroll.position.maxScrollExtent <= 0) {
        ref.read(exploreProvider.notifier).loadMore();
      }
    });
  }

  // Debounce lives in ExploreNotifier.setQuery.
  // When the query is non-empty the notifier uses searchCourses,
  // otherwise it uses getCourses.
  void _onSearchChanged(String value) {
    ref.read(exploreProvider.notifier).setQuery(value);
  }

  void _openDetails(StudentCourseEntity course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentCourseDetailsScreen(course: course),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exploreProvider);
    final notifier = ref.read(exploreProvider.notifier);
    final subjectsAsync = ref.watch(exploreSubjectsProvider);
    final subjects = subjectsAsync.value ?? const <String>[];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'Explore',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: ExploreSearchBar(
                initialValue: state.query,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchChanged,
              ),
            ),
            ExploreSubjectChips(
              subjects: subjects,
              selected: state.subject,
              onSelected: notifier.setSubject,
              loading: subjectsAsync.isLoading,
              hasError: subjectsAsync.hasError,
              onRetry: () => ref.invalidate(exploreSubjectsProvider),
            ),
            const SizedBox(height: 12),
            Expanded(child: _body(state, notifier)),
          ],
        ),
      ),
    );
  }

  Widget _body(ExploreState state, ExploreNotifier notifier) {
    if (state.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // First-page error
    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              onPressed: notifier.refresh,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.items.isNotEmpty) _loadMoreIfNotScrollable();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: notifier.refresh,
      child: state.items.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        children: const [ExploreEmptyView()],
      )
          : ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, _bottomSpace),
        itemCount: state.items.length + 1,
        itemBuilder: (_, i) {
          if (i == state.items.length) {
            return ExploreListFooter(
              loading: state.loadingMore,
              hasMore: state.hasMore,
              error: state.error,
              onRetry: () => notifier.loadMore(retry: true),
            );
          }
          final course = state.items[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StudentCourseCard(
              key: ValueKey(course.id),
              course: course,
              onTap: () => _openDetails(course),
            ),
          );
        },
      ),
    );
  }
}