import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

/// Floating card with rating, experience and completed sessions.
class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    required this.rating,
    required this.yearsOfExperience,
    required this.completedSessions,
  });

  /// Fixed height so the header can overlap it precisely.
  static const double height = 84;

  final double rating;
  final int yearsOfExperience;
  final int completedSessions;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              value: rating.toStringAsFixed(1),
              label: 'Rating',
              icon: Icons.star_rounded,
              iconColor: AppColors.ratingStar,
            ),
          ),
          const _StatDivider(),
          Expanded(
            child: _StatItem(
              value: '$yearsOfExperience',
              label: 'Years exp.',
            ),
          ),
          const _StatDivider(),
          Expanded(
            child: _StatItem(
              value: '$completedSessions',
              label: 'Sessions',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    this.icon,
    this.iconColor,
  });

  final String value;
  final String label;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 2),
            ],
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
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
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.border);
  }
}