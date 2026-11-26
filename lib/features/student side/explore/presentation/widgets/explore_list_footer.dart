import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class ExploreListFooter extends StatelessWidget {
  const ExploreListFooter({
    super.key,
    required this.loading,
    required this.hasMore,
  });

  final bool loading;
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
                strokeWidth: 2.5, color: AppColors.primary),
          ),
        ),
      );
    }
    if (!hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            "You've reached the end",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ),
      );
    }
    return const SizedBox(height: 20);
  }
}