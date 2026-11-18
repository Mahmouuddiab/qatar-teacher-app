import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/core/widgets/app_snackbar.dart';
import '../providers/teacher_booking_providers.dart';

Future<void> respondToBooking(
    BuildContext context,
    WidgetRef ref,
    int id, {
      required bool accept,
    }) async {
  if (!accept) {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reject booking?'),
        content: const Text('The student will be notified that you declined.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reject', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
  }

  final error =
  await ref.read(bookingActionProvider.notifier).respond(id, accept);

  if (error != null) {
    AppSnackBar.error(error);
  } else if (accept) {
    AppSnackBar.success('Booking accepted');
  } else {
    AppSnackBar.warning('Booking rejected');
  }
}