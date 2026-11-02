import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

import 'profile_section_card.dart';

/// Titled card with a paragraph of text (About, Qualifications).
/// Renders nothing when [text] is null or empty.
class ProfileTextSection extends StatelessWidget {
  const ProfileTextSection({
    super.key,
    required this.title,
    required this.icon,
    required this.text,
  });

  final String title;
  final IconData icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final value = text?.trim();
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return ProfileSectionCard(
      title: title,
      icon: icon,
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 14,
          height: 1.6,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}