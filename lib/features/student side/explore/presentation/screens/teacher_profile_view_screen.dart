import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../../../../core/utils/course_formatters.dart';
import '../providers/student_explore_providers.dart';
import '../widgets/course_chip.dart';
import '../widgets/teacher_info_block.dart';
import '../widgets/teacher_profile_heade.dart';
import '../widgets/teacher_stats_row.dart';

class TeacherProfileViewScreen extends ConsumerWidget {
  const TeacherProfileViewScreen({
    super.key,
    required this.teacherId,
    required this.fallbackName,
    required this.fallbackSubject,
  });

  final int teacherId;

  /// From the course, shown immediately while the profile loads.
  final String fallbackName;
  final String fallbackSubject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(teacherProfileProvider(teacherId));
    final p = profile.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Teacher Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: profile.hasError && p == null && !profile.isLoading
          ? _ErrorView(
        onRetry: () => ref.invalidate(teacherProfileProvider(teacherId)),
      )
          : RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(teacherProfileProvider(teacherId));
          try {
            await ref.read(teacherProfileProvider(teacherId).future);
          } catch (_) {}
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            TeacherProfileHeader(
              name: p?.name ?? fallbackName,
              subtitle: p != null && p.subjects.isNotEmpty
                  ? p.subjects.join(' • ')
                  : '$fallbackSubject teacher',
              rating: p?.rating,
            ),
            if (profile.isLoading && p == null) ...[
              const SizedBox(height: 24),
              const LinearProgressIndicator(
                minHeight: 2,
                color: AppColors.primary,
                backgroundColor: AppColors.primaryLight,
              ),
            ],
            if (p != null) ...[
              const SizedBox(height: 24),
              TeacherStatsRow(
                experience: '${p.yearsOfExperience} yr',
                sessions: '${p.completedSessions}',
                rate: formatQar(p.hourlyRateQAR),
              ),
              if (p.bio.isNotEmpty) ...[
                const SizedBox(height: 28),
                TeacherInfoBlock(
                  title: 'About',
                  child: Text(
                    p.bio,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.7,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              if (p.qualifications.isNotEmpty) ...[
                const SizedBox(height: 20),
                TeacherInfoBlock(
                  title: 'Qualifications',
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.workspace_premium_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          p.qualifications,
                          style: const TextStyle(
                            fontSize: 14.5,
                            height: 1.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (p.subjects.isNotEmpty) ...[
                const SizedBox(height: 20),
                TeacherInfoBlock(
                  title: 'Subjects',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final s in p.subjects) CourseChip(text: s),
                    ],
                  ),
                ),
              ],
              if (p.languages.isNotEmpty) ...[
                const SizedBox(height: 20),
                TeacherInfoBlock(
                  title: 'Languages',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final l in p.languages) CourseChip(text: l),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          const Text(
            "Couldn't load the teacher profile",
            style: TextStyle(color: AppColors.textSecondary),
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