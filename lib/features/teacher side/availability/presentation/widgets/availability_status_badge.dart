import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class AvailabilityStatusBadge extends StatelessWidget {
  const AvailabilityStatusBadge({super.key, required this.isBooked});

  final bool isBooked;

  @override
  Widget build(BuildContext context) {
    final color = isBooked ? AppColors.success : AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isBooked ? 'Booked' : 'Available',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}