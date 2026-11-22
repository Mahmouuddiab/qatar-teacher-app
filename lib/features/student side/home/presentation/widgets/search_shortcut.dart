import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class SearchShortcut extends StatelessWidget {
  const SearchShortcut({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppColors.textSecondary),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search courses or teachers',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}