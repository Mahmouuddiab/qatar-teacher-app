import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class ExploreSubjectChips extends StatelessWidget {
  const ExploreSubjectChips({
    super.key,
    required this.subjects,
    required this.selected,
    required this.onSelected,
  });

  final List<String> subjects;

  /// null = "All"
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final all = <String?>[null, ...subjects];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final value = all[i];
          final isSelected = value == selected;
          return ChoiceChip(
            label: Text(value ?? 'All'),
            selected: isSelected,
            showCheckmark: false,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onSelected(value),
          );
        },
      ),
    );
  }
}