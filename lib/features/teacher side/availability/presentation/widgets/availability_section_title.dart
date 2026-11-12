import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class AvailabilitySectionTitle extends StatelessWidget {
  const AvailabilitySectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}