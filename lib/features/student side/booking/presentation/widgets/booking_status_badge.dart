import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'student_booking_ui.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final MyBookingStatus status;

  Color get _color => switch (status) {
    MyBookingStatus.pending => AppColors.ratingStar,
    MyBookingStatus.confirmed => AppColors.success,
    MyBookingStatus.completed => AppColors.primary,
    MyBookingStatus.cancelled => AppColors.red,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}