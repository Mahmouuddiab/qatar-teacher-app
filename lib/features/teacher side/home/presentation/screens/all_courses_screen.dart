import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../providers/teacher_home_providers.dart';
import '../widgets/course_card.dart';

class AllCoursesScreen extends ConsumerWidget {
  const AllCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'All Courses',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addCourse),
        icon: const Icon(Icons.add),
        label: const Text('Add Course'),
      ),
      body: coursesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => _MessageView(
          icon: Icons.error_outline,
          message: e is Failure ? e.message : 'Failed to load courses',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(coursesProvider),
        ),
        data: (courses) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ref.read(coursesProvider.notifier).refresh(),
          child: courses.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 120),
                    _MessageView(
                      icon: Icons.menu_book_outlined,
                      message: 'No courses yet',
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: courses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final c = courses[i];
                    return CourseCard(
                      title: c.title,
                      subject: c.subject,
                      level: c.level,
                      pricePerSessionQAR: c.pricePerSessionQAR,
                      durationMinutes: c.durationMinutes,
                      sessionMode: c.sessionMode,
                      isActive: c.isActive,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.courseDetails,
                        arguments: c.id,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageView({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 8),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
