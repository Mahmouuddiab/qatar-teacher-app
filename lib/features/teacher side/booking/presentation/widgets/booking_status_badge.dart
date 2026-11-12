import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

import '../models/booking_ui_model.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({super.key, required this.status});

  final BookingStatus status;

  // Darker amber so the text stays readable on the light amber background
  static const Color _pendingText = Color(0xFFB77900);

  Color get _color => switch (status) {
    BookingStatus.pending => _pendingText,
    BookingStatus.confirmed => AppColors.primary,
    BookingStatus.completed => AppColors.success,
    BookingStatus.cancelled => AppColors.red,
  };

  Color get _background => switch (status) {
    BookingStatus.pending => AppColors.ratingStar.withOpacity(0.15),
    BookingStatus.confirmed => AppColors.primaryLight,
    BookingStatus.completed => AppColors.success.withOpacity(0.1),
    BookingStatus.cancelled => AppColors.red.withOpacity(0.1),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _color,
        ),
      ),
    );
  }
}