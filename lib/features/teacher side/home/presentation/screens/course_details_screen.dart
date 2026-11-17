import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../domain/entities/course_entity.dart';
import '../providers/teacher_home_providers.dart';

class CourseDetailsScreen extends ConsumerWidget {
  final int courseId;
  const CourseDetailsScreen({super.key, required this.courseId});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete course?'),
        content: const Text(
          'This action cannot be undone. The course will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(deleteCourseProvider.notifier).deleteCourse(courseId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailsProvider(courseId));
    final deleteState = ref.watch(deleteCourseProvider);

    ref.listen<DeleteCourseState>(deleteCourseProvider, (prev, next) {
      if (next.status == DeleteCourseStatus.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Course deleted')));
        Navigator.pop(context);
      } else if (next.status == DeleteCourseStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Delete failed')),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Course Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          courseAsync.maybeWhen(
            data: (course) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: deleteState.isLoading
                      ? null
                      : () => Navigator.pushNamed(
                    context,
                    AppRoutes.editCourse,
                    arguments: course,
                  ),
                ),
                deleteState.isLoading
                    ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.red,
                    ),
                  ),
                )
                    : IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.red,
                  ),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: courseAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                Text(
                  e is Failure ? e.message : 'Failed to load course',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () =>
                      ref.invalidate(courseDetailsProvider(courseId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (course) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(courseDetailsProvider(courseId));
            await ref.read(courseDetailsProvider(courseId).future);
          },
          child: _CourseDetailsBody(course: course),
        ),
      ),
    );
  }
}

class _CourseDetailsBody extends StatelessWidget {
  final CourseEntity course;
  const _CourseDetailsBody({required this.course});

  String _formatDate(DateTime d) {
    final l = d.toLocal();
    return '${l.day.toString().padLeft(2, '0')}/'
        '${l.month.toString().padLeft(2, '0')}/${l.year}';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = course.isActive
        ? AppColors.success
        : AppColors.textSecondary;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // ---- Header card ----
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _Badge(
                    text: course.isActive ? 'Active' : 'Inactive',
                    color: statusColor,
                    background: statusColor.withOpacity(0.12),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    course.teacherName,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _Badge(text: course.subject),
                  _Badge(text: course.level),
                  _Badge(text: course.sessionMode),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ---- Price & duration ----
        Row(
          children: [
            Expanded(
              child: _HighlightTile(
                icon: Icons.payments_outlined,
                label: 'Price / session',
                value: '${course.pricePerSessionQAR} QAR',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _HighlightTile(
                icon: Icons.timer_outlined,
                label: 'Duration',
                value: '${course.durationMinutes} min',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ---- Description ----
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                course.description.isEmpty
                    ? 'No description provided.'
                    : course.description,
                style: const TextStyle(
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const Divider(height: 28, color: AppColors.border),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Created',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                  Text(
                    _formatDate(course.createdAt),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final Color background;

  const _Badge({
    required this.text,
    this.color = AppColors.primary,
    this.background = AppColors.primaryLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HighlightTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}