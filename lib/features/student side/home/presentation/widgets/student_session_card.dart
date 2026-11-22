import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/core/utils/student_formatters.dart';
import '../../domain/entities/student_booking_entity.dart';
import 'app_tag.dart';

class StudentSessionCard extends StatelessWidget {
  const StudentSessionCard({super.key, required this.session});

  final StudentBookingEntity session;

  @override
  Widget build(BuildContext context) {
    final isOnline = session.mode.toLowerCase() == 'online';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isOnline ? Icons.videocam_outlined : Icons.place_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'with ${session.teacherName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _Meta(
                      icon: Icons.calendar_today_outlined,
                      text: session.sessionDate.sessionDateLabel,
                    ),
                    _Meta(
                      icon: Icons.access_time_rounded,
                      text: session.sessionDate.sessionTimeLabel,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppTag(text: session.mode, color: AppColors.success),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12.5)),
      ],
    );
  }
}
