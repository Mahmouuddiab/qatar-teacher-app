import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../domain/entities/student_booking_entity.dart';
import '../../domain/entities/student_course_entity.dart';
import '../providers/student_home_providers.dart';
import '../widgets/greeting_header.dart';
import '../widgets/home_empty_box.dart';
import '../widgets/home_section_title.dart';
import '../widgets/search_shortcut.dart';
import '../widgets/student_course_card.dart';
import '../widgets/student_session_card.dart';
import '../widgets/subjects_row.dart';

abstract final class _Gap {
  static const double xs = 12;
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  // Space for the floating bottom nav bar
  static const double bottomNav = 120;
}

class StudentHomeScreen extends ConsumerWidget {
  const StudentHomeScreen({
    super.key,
    required this.userName,
    required this.onNotificationsTap,
    required this.onSearchTap,
    required this.onViewAllSessions,
    required this.onViewAllCourses,
    required this.onCourseTap,
  });

  /// Comes from the profile; the parent (tab shell) passes it in.
  final String userName;

  /// Open the notifications screen.
  final VoidCallback onNotificationsTap;

  /// Switch to the Explore tab.
  final VoidCallback onSearchTap;

  /// Switch to the Bookings tab.
  final VoidCallback onViewAllSessions;

  /// Switch to the Explore tab.
  final VoidCallback onViewAllCourses;

  /// Open course details.
  final ValueChanged<StudentCourseEntity> onCourseTap;

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(subjectsProvider);
    ref.invalidate(latestCoursesProvider);
    ref.invalidate(upcomingSessionsProvider);
    await Future.wait([
      ref.read(subjectsProvider.future).then((_) {}, onError: (_) {}),
      ref.read(latestCoursesProvider.future).then((_) {}, onError: (_) {}),
      ref.read(upcomingSessionsProvider.future).then((_) {}, onError: (_) {}),
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => _refresh(ref),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    _Gap.sm,
                    _Gap.sm,
                    _Gap.sm,
                    _Gap.bottomNav,
                  ),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GreetingHeader(
                              name: userName,
                              onNotificationsTap: onNotificationsTap,
                            ),
                            const SizedBox(height: _Gap.sm),
                            SearchShortcut(onTap: onSearchTap),
                            const SizedBox(height: _Gap.md),
                            const SubjectsRow(),
                            const SizedBox(height: _Gap.lg),
                            HomeSectionTitle(
                              title: 'Upcoming Sessions',
                              onViewAll: onViewAllSessions,
                            ),
                            const SizedBox(height: _Gap.xs),
                          ],
                        ),
                      ),
                      const _SessionsSection(),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: _Gap.lg),
                            HomeSectionTitle(
                              title: 'Recommended Courses',
                              onViewAll: onViewAllCourses,
                            ),
                            const SizedBox(height: _Gap.xs),
                          ],
                        ),
                      ),
                      _CoursesSection(onCourseTap: onCourseTap),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Watches only the sessions provider, so it rebuilds independently.
class _SessionsSection extends ConsumerWidget {
  const _SessionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _AsyncSliverList<StudentBookingEntity>(
      value: ref.watch(upcomingSessionsProvider),
      onRetry: () => ref.invalidate(upcomingSessionsProvider),
      errorFallback: 'Failed to load sessions',
      emptyIcon: Icons.event_busy_outlined,
      emptyMessage: 'No upcoming sessions',
      itemBuilder: (session) => StudentSessionCard(session: session),
    );
  }
}

/// Watches only the courses provider, so it rebuilds independently.
class _CoursesSection extends ConsumerWidget {
  const _CoursesSection({required this.onCourseTap});

  final ValueChanged<StudentCourseEntity> onCourseTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _AsyncSliverList<StudentCourseEntity>(
      value: ref.watch(latestCoursesProvider),
      onRetry: () => ref.invalidate(latestCoursesProvider),
      errorFallback: 'Failed to load courses',
      emptyIcon: Icons.menu_book_outlined,
      emptyMessage: 'No courses found',
      itemBuilder: (course) => StudentCourseCard(
        key: ValueKey(course.id),
        course: course,
        onTap: () => onCourseTap(course),
      ),
    );
  }
}

/// Shared loading / error / empty / data handling for a list section.
/// Items are built lazily through [SliverList.separated].
class _AsyncSliverList<T> extends StatelessWidget {
  const _AsyncSliverList({
    required this.value,
    required this.onRetry,
    required this.errorFallback,
    required this.emptyIcon,
    required this.emptyMessage,
    required this.itemBuilder,
  });

  final AsyncValue<List<T>> value;
  final VoidCallback onRetry;
  final String errorFallback;
  final IconData emptyIcon;
  final String emptyMessage;
  final Widget Function(T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      // Keep showing the old list while a pull-to-refresh reloads.
      skipLoadingOnReload: true,
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: _Gap.lg),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: _ErrorView(
          message: e is Failure ? e.message : errorFallback,
          onRetry: onRetry,
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return SliverToBoxAdapter(
            child: HomeEmptyBox(icon: emptyIcon, message: emptyMessage),
          );
        }
        return SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: _Gap.xs),
          itemBuilder: (_, i) => itemBuilder(items[i]),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _Gap.sm),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}