import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'course_section_title.dart';

class CourseAboutSection extends StatelessWidget {
  const CourseAboutSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CourseSectionTitle('About this course'),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            description.isEmpty ? 'No description provided.' : description,
            style: const TextStyle(
              fontSize: 14.5,
              height: 1.7,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}