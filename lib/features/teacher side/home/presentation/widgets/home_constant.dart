import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

const Color kHomePrimary = AppColors.primary;
const Color kHomePrimaryLight = AppColors.primaryLight;
const Color kHomeBorder = AppColors.border;
const Color kHomeMuted = AppColors.textSecondary;

BoxDecoration homeCardDecoration() => BoxDecoration(
  color: AppColors.surface,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: kHomeBorder),
);
