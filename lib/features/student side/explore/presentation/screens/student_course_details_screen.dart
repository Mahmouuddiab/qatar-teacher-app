import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../../../../core/utils/course_formatters.dart';
import '../../../booking/presentation/widgets/book_course_sheet.dart';
import '../../../home/domain/entities/student_course_entity.dart';
import '../providers/student_explore_providers.dart';
import '../widgets/course_about_section.dart';
import '../widgets/course_bottom_bar.dart';
import '../widgets/course_error_note.dart';
import '../widgets/course_facts_card.dart';
import '../widgets/course_header.dart';
import '../widgets/course_teacher_section.dart';
import 'teacher_profile_view_screen.dart';

class StudentCourseDetailsScreen extends ConsumerWidget {
  const StudentCourseDetailsScreen({super.key, required this.course});

  /// Shown immediately while the details request loads, and used as a
  /// fallback if the request fails.
  final StudentCourseEntity course;

  void _openTeacher(BuildContext context, StudentCourseEntity c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherProfileViewScreen(
          teacherId: c.teacherId,
          fallbackName: c.teacherName,
          fallbackSubject: c.subject,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(courseDetailsProvider(course.id));
    final c = details.value ?? course;
    final price = formatQar(c.pricePerSessionQAR);

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
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(courseDetailsProvider(course.id));
          try {
            await ref.read(courseDetailsProvider(course.id).future);
          } catch (_) {}
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            if (details.isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: LinearProgressIndicator(
                  minHeight: 2,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                ),
              ),
            if (details.hasError && !details.isLoading)
              CourseErrorNote(
                onRetry: () => ref.invalidate(courseDetailsProvider(course.id)),
              ),
            CourseHeader(
              title: c.title,
              teacherName: c.teacherName,
              subject: c.subject,
              level: c.level,
            ),
            const SizedBox(height: 24),
            CourseFactsCard(
              price: price,
              duration: '${c.durationMinutes} min',
              mode: modeLabel(c.sessionMode),
            ),
            const SizedBox(height: 28),
            CourseAboutSection(description: c.description),
            const SizedBox(height: 28),
            CourseTeacherSection(
              name: c.teacherName,
              subject: c.subject,
              onTap: () => _openTeacher(context, c),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CourseBottomBar(
        price: price,
        isActive: c.isActive,
        onBook: () => showBookCourseSheet(context, c),
      ),
    );
  }
}