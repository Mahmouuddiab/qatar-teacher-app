import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class TeacherStatsRow extends StatelessWidget {
  const TeacherStatsRow({
    super.key,
    required this.experience,
    required this.sessions,
    required this.rate,
  });

  final String experience;
  final String sessions;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _Stat(value: experience, label: 'Experience'),
            const VerticalDivider(
                width: 1, thickness: 1, color: AppColors.border),
            _Stat(value: sessions, label: 'Sessions'),
            const VerticalDivider(
                width: 1, thickness: 1, color: AppColors.border),
            _Stat(value: rate, label: 'Per hour'),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
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