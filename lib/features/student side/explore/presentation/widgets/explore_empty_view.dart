import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class ExploreEmptyView extends StatelessWidget {
  const ExploreEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 80, 32, 0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded,
                size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          const Text(
            'No courses found',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try a different search or subject.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}