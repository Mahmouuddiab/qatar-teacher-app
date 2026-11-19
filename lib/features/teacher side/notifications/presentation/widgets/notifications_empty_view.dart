import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class NotificationsEmptyView extends StatelessWidget {
  const NotificationsEmptyView({super.key, required this.unreadOnly});

  final bool unreadOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_none_rounded,
            size: 56,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            unreadOnly ? 'No unread notifications' : 'No notifications yet',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}