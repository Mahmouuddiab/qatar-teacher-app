import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class ExploreEmptyView extends StatelessWidget {
  const ExploreEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded,
              size: 56, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text('No courses found',
              style: TextStyle(color: AppColors.textSecondary)),
          SizedBox(height: 4),
          Text('Try another keyword or subject',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}