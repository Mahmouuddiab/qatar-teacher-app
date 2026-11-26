import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class ExploreSubjectChips extends StatelessWidget {
  const ExploreSubjectChips({
    super.key,
    required this.subjects,
    required this.selected,
    required this.onSelected,
    this.loading = false,
    this.hasError = false,
    this.onRetry,
  });

  final List<String> subjects;
  final String? selected; // null = All
  final ValueChanged<String?> onSelected;

  /// Subjects request in flight: shows placeholders after the "All" chip.
  final bool loading;

  /// Subjects request failed: shows a retry chip after the "All" chip.
  final bool hasError;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final items = <String?>[null, ...subjects];

    final trailing = <Widget>[
      if (loading) ...[
        const _Placeholder(width: 80),
        const _Placeholder(width: 96),
        const _Placeholder(width: 70),
      ] else if (hasError && onRetry != null)
        _RetryChip(onTap: onRetry!),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length + trailing.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i >= items.length) return trailing[i - items.length];

          final value = items[i];
          final isSelected = value == selected;
          return ChoiceChip(
            label: Text(value ?? 'All'),
            selected: isSelected,
            showCheckmark: false,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            onSelected: (_) => onSelected(value),
          );
        },
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.border.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _RetryChip extends StatelessWidget {
  const _RetryChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: const Icon(
        Icons.refresh_rounded,
        size: 16,
        color: AppColors.textSecondary,
      ),
      label: const Text('Retry subjects'),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
      onPressed: onTap,
    );
  }
}