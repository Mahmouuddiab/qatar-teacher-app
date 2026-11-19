import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

enum NotificationFilter {
  all('All'),
  unread('Unread');

  const NotificationFilter(this.label);
  final String label;
}

class NotificationsFilterBar extends StatelessWidget {
  const NotificationsFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final NotificationFilter selected;
  final ValueChanged<NotificationFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        children: [
          for (final f in NotificationFilter.values)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: ChoiceChip(
                label: Text(f.label),
                selected: f == selected,
                showCheckmark: false,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
                labelStyle: TextStyle(
                  color: f == selected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                onSelected: (_) => onSelected(f),
              ),
            ),
        ],
      ),
    );
  }
}