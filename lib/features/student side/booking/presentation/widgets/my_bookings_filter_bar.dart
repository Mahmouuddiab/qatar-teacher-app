import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'student_booking_ui.dart';

class MyBookingsFilterBar extends StatelessWidget {
  const MyBookingsFilterBar({
    super.key,
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  final MyBookingFilter selected;
  final Map<MyBookingFilter, int> counts;
  final ValueChanged<MyBookingFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: MyBookingFilter.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = MyBookingFilter.values[i];
          final isSelected = f == selected;
          return ChoiceChip(
            label: Text('${f.label}  ${counts[f] ?? 0}'),
            selected: isSelected,
            showCheckmark: false,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            side: const BorderSide(color: AppColors.border),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            onSelected: (_) => onSelected(f),
          );
        },
      ),
    );
  }
}
