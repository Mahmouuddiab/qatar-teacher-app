import 'package:flutter/material.dart';
import 'home_constant.dart';

class UpcomingSessionTile extends StatelessWidget {
  final String courseTitle;
  final String studentName;
  final String date;
  final String time;
  final String mode;

  const UpcomingSessionTile({
    super.key,
    required this.courseTitle,
    required this.studentName,
    required this.date,
    required this.time,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: homeCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: kHomePrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.event, color: kHomePrimary, size: 20),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    color: kHomePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  courseTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  studentName,
                  style: const TextStyle(color: kHomeMuted, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: kHomeMuted),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(color: kHomeMuted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: kHomeBorder),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              mode,
              style: const TextStyle(fontSize: 12, color: kHomeMuted),
            ),
          ),
        ],
      ),
    );
  }
}