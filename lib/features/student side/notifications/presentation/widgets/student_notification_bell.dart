import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../providers/student_notifications_providers.dart';

class StudentNotificationBell extends ConsumerWidget {
  const StudentNotificationBell({super.key, required this.onTap});

  /// Open the notifications screen. The badge refreshes when it closes.
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // No badge while loading or on error; the bell still works
    final count = ref.watch(studentUnreadCountProvider).value ?? 0;

    return Tooltip(
      message: 'Notifications',
      child: Material(
        color: AppColors.primaryLight,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
            await onTap();
            ref.invalidate(studentUnreadCountProvider);
          },
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: Badge(
                isLabelVisible: count > 0,
                label: Text(count > 99 ? '99+' : '$count'),
                backgroundColor: AppColors.red,
                child: const Icon(
                  Icons.notifications_none_rounded,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}