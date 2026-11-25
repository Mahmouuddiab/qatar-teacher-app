import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'student_booking_ui.dart';

class MyBookingsEmptyView extends StatelessWidget {
  const MyBookingsEmptyView({super.key, required this.filter});

  final MyBookingFilter filter;

  @override
  Widget build(BuildContext context) {
    final message = filter == MyBookingFilter.all
        ? 'No bookings yet'
        : 'No ${filter.label.toLowerCase()} bookings';

    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Column(
        children: [
          const Icon(
            Icons.event_busy_outlined,
            size: 56,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}