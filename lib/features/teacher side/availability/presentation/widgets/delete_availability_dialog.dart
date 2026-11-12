import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

/// Returns true if the user confirmed the deletion.
Future<bool> showDeleteAvailabilityDialog(
    BuildContext context, {
      required bool isRecurring,
    }) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Delete availability?',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        isRecurring
            ? 'This weekly slot will be removed.'
            : 'This one-time slot will be removed.',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text(
            'Delete',
            style: TextStyle(
              color: AppColors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );

  return result ?? false;
}