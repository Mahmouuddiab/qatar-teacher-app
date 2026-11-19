import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../../notifications/presentation/providers/teacher_notifications_providers.dart';
import '../../../notifications/presentation/widgets/notification_bell.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../providers/teacher_home_providers.dart';
import '../widgets/course_card.dart';
import '../widgets/home_constant.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/upcoming_session_tile.dart';

class TeacherHomeScreen extends ConsumerWidget {
  const TeacherHomeScreen({super.key});

  static const int _previewCount = 3;
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  void _goToAddCourse(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addCourse);
  }

  // ---------- formatting helpers ----------

  String _formatDate(DateTime? d) {
    if (d == null) return '-';
    final l = d.toLocal();
    return '${l.day} ${_months[l.month - 1]}';
  }

  /// "17:00" -> "05:00 PM". Returns the input unchanged if it can't be parsed.
  String _formatTime(String t) {
    final parts = t.split(':');
    if (parts.length < 2) return t;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return t;
    final period = h >= 12 ? 'PM' : 'AM';
    final h12 = h % 12 == 0 ? 12 : h % 12;
    return '${h12.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')} $period';
  }

  String _formatNumber(num v, {int decimals = 2}) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(decimals);

  // ---------- sections ----------

  Widget _buildGreeting(String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name.isEmpty ? '' : 'Hello, $name',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
          const NotificationBell(),
        ],
      ),
    );
  }

  List<Widget> _buildSessions(
      WidgetRef ref,
      AsyncValue<DashboardEntity> dashboardAsync,
      ) {
    return dashboardAsync.when(
      loading: () => const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      ],
      error: (e, _) => [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(
                e is Failure ? e.message : 'Failed to load sessions',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => ref.invalidate(dashboardProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ],
      data: (dashboard) {
        final sessions = dashboard.upcomingSessions;
        if (sessions.isEmpty) {
          return const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No upcoming sessions',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ];
        }
        return [
          for (int i = 0; i < sessions.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            UpcomingSessionTile(
              courseTitle: sessions[i].courseTitle,
              studentName: sessions[i].studentName,
              date: _formatDate(sessions[i].date),
              time:
              '${_formatTime(sessions[i].startTime)} - ${_formatTime(sessions[i].endTime)}',
              mode: sessions[i].mode,
            ),
          ],
        ];
      },
    );
  }

  List<Widget> _buildCourses(
      BuildContext context,
      WidgetRef ref,
      AsyncValue<List<CourseEntity>> coursesAsync,
      ) {
    return coursesAsync.when(
      loading: () => const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
      error: (e, _) => [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Text(
                e is Failure ? e.message : 'Failed to load courses',
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => ref.invalidate(coursesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ],
      data: (courses) {
        if (courses.isEmpty) {
          return const [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('No courses yet')),
            ),
          ];
        }
        final preview = courses.take(_previewCount).toList();
        return [
          for (int i = 0; i < preview.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            CourseCard(
              title: preview[i].title,
              subject: preview[i].subject,
              level: preview[i].level,
              pricePerSessionQAR: preview[i].pricePerSessionQAR,
              durationMinutes: preview[i].durationMinutes,
              sessionMode: preview[i].sessionMode,
              isActive: preview[i].isActive,
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.courseDetails,
                arguments: preview[i].id,
              ),
            ),
          ],
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);
    final dashboardAsync = ref.watch(dashboardProvider);

    // Stat values show "-" while loading or on error
    final dashboard = dashboardAsync.value;
    String stat(String Function(DashboardEntity d) pick) =>
        dashboard == null ? '-' : pick(dashboard);

    final activeCourses = coursesAsync.maybeWhen(
      data: (courses) => courses.where((c) => c.isActive).length.toString(),
      orElse: () => '-',
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.invalidate(dashboardProvider);
              ref.invalidate(unreadCountProvider);
              await Future.wait([
                ref
                    .read(dashboardProvider.future)
                    .then((_) {}, onError: (_) {}),
                ref.read(coursesProvider.notifier).refresh(),
              ]);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // ---- Greeting + notifications bell ----
                _buildGreeting(dashboard?.teacherName ?? ''),
                const SectionHeader(title: 'Dashboard'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.payments_outlined,
                        value: stat(
                              (d) => '${_formatNumber(d.totalEarningsQAR)} QAR',
                        ),
                        label: 'Total earnings',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.star_outline_rounded,
                        value: stat(
                              (d) => _formatNumber(d.averageRating, decimals: 1),
                        ),
                        label: 'Average rating',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.hourglass_empty_rounded,
                        value: stat((d) => d.pendingRequests.toString()),
                        label: 'Pending requests',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.upcoming_outlined,
                        value: stat((d) => d.upcomingClasses.toString()),
                        label: 'Upcoming',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.menu_book_outlined,
                        value: activeCourses,
                        label: 'Active courses',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.check_circle_outline,
                        value: stat((d) => d.completedClasses.toString()),
                        label: 'Completed',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ---- Quick action ----
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _goToAddCourse(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Course'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kHomePrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ---- Upcoming sessions (from dashboard) ----
                SectionHeader(
                  title: 'Upcoming Sessions',
                  actionText: 'See all',
                  onAction: () {}, // TODO: go to bookings tab
                ),
                const SizedBox(height: 12),
                ..._buildSessions(ref, dashboardAsync),
                const SizedBox(height: 24),

                // ---- My courses (from API) ----
                SectionHeader(
                  title: 'My Courses',
                  actionText: 'See all',
                  onAction: () =>
                      Navigator.pushNamed(context, AppRoutes.allCourses),
                ),
                const SizedBox(height: 12),
                ..._buildCourses(context, ref, coursesAsync),

                // space for the floating bottom nav bar
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}