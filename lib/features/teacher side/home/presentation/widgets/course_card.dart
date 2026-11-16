import 'package:flutter/material.dart';
import 'home_constant.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String subject;
  final String level;
  final num pricePerSessionQAR;
  final int durationMinutes;
  final String sessionMode;
  final bool isActive;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    required this.subject,
    required this.level,
    required this.pricePerSessionQAR,
    required this.durationMinutes,
    required this.sessionMode,
    this.isActive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: homeCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _StatusChip(isActive: isActive),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '$subject • $level',
              style: const TextStyle(color: kHomeMuted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Info(icon: Icons.payments_outlined, text: '$pricePerSessionQAR QAR'),
                const SizedBox(width: 16),
                _Info(icon: Icons.timer_outlined, text: '$durationMinutes min'),
                const SizedBox(width: 16),
                _Info(icon: Icons.videocam_outlined, text: sessionMode),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Info({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: kHomePrimary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isActive;

  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.green : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: color.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}