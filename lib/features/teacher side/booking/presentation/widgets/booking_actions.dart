import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

import '../models/booking_ui_model.dart';

class BookingActions extends StatelessWidget {
  const BookingActions({
    super.key,
    required this.status,
    this.onAccept,
    this.onReject,
    this.onComplete,
  });

  final BookingStatus status;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onComplete;

  static final _shape =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case BookingStatus.pending:
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.red,
                    side: const BorderSide(color: AppColors.red),
                    shape: _shape,
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: onAccept,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: _shape,
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        );

      case BookingStatus.confirmed:
        return SizedBox(
          width: double.infinity,
          height: 44,
          child: FilledButton.icon(
            onPressed: onComplete,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.white,
              shape: _shape,
            ),
            icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
            label: const Text(
              'Complete session',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        );

      case BookingStatus.completed:
      case BookingStatus.cancelled:
        return const SizedBox.shrink();
    }
  }
}