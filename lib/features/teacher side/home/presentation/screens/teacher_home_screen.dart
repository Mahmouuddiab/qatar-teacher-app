import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../domain/entities/course_entity.dart';
import '../providers/teacher_home_providers.dart';
import '../widgets/course_card.dart';
import '../widgets/home_constant.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_card.dart';
import '../widgets/upcoming_session_tile.dart';

class TeacherHomeScreen extends ConsumerWidget {
  const TeacherHomeScreen({super.key});

  static const int _previewCount = 3;

  void _goToAddCourse(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.addCourse);
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
            onRefresh: () => ref.read(coursesProvider.notifier).refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const SectionHeader(title: 'Dashboard'),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.event_available_outlined,
                        value: '24',
                        label: 'Total bookings',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatCard(
                        icon: Icons.upcoming_outlined,
                        value: '5',
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
                    const Expanded(
                      child: StatCard(
                        icon: Icons.check_circle_outline,
                        value: '16',
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

                // ---- Upcoming sessions preview ----
                SectionHeader(
                  title: 'Upcoming Sessions',
                  actionText: 'See all',
                  onAction: () {}, // TODO: go to bookings tab
                ),
                const SizedBox(height: 12),
                const UpcomingSessionTile(
                  courseTitle: 'Mathematics for Beginners',
                  studentName: 'Ahmed Ali',
                  date: '17 Nov',
                  time: '04:00 PM - 05:00 PM',
                  mode: 'Online',
                ),
                const SizedBox(height: 12),
                const UpcomingSessionTile(
                  courseTitle: 'Algebra Essentials',
                  studentName: 'Sara Hassan',
                  date: '18 Nov',
                  time: '06:00 PM - 07:00 PM',
                  mode: 'In person',
                ),
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
