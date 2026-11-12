import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../models/booking_ui_model.dart';

class BookingsEmptyView extends StatelessWidget {
  const BookingsEmptyView({super.key, required this.filter});

  final BookingFilter filter;

  @override
  Widget build(BuildContext context) {
    final isAll = filter == BookingFilter.all;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_note_outlined,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No bookings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isAll
                  ? 'Bookings from students will appear here.'
                  : 'You have no ${filter.label.toLowerCase()} bookings.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}