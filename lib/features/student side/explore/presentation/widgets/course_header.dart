import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'course_chip.dart';

class CourseHeader extends StatelessWidget {
  const CourseHeader({
    super.key,
    required this.title,
    required this.teacherName,
    required this.subject,
    required this.level,
  });

  final String title;
  final String teacherName;
  final String subject;
  final String level;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            CourseChip(text: subject),
            CourseChip(text: level),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            height: 1.2,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(
              Icons.person_outline_rounded,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                teacherName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}