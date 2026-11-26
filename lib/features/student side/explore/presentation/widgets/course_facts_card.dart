import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class CourseFactsCard extends StatelessWidget {
  const CourseFactsCard({
    super.key,
    required this.price,
    required this.duration,
    required this.mode,
  });

  final String price;
  final String duration;
  final String mode;

  IconData get _modeIcon {
    final m = mode.toLowerCase();
    if (m.contains('online') && m.contains('person')) {
      return Icons.swap_horiz_rounded;
    }
    if (m.contains('online')) return Icons.videocam_outlined;
    if (m.contains('person')) return Icons.location_on_outlined;
    return Icons.school_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Fact(
            icon: Icons.payments_outlined,
            label: 'Price',
            value: price,
          ),
          const SizedBox(width: 10),
          _Fact(
            icon: Icons.timer_outlined,
            label: 'Duration',
            value: duration,
          ),
          const SizedBox(width: 10),
          _Fact(icon: _modeIcon, label: 'Mode', value: mode),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}