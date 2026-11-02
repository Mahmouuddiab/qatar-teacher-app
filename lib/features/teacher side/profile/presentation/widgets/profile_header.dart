import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

/// Gradient hero header: title bar, avatar, name and hourly rate.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.hourlyRate,
    required this.onEditProfile,
  });

  final String name;
  final double hourlyRate;
  final VoidCallback onEditProfile;

  /// Translucent white used for glass-style pills and buttons.
  static const Color _glass = Color(0x26FFFFFF);

  String get _initial =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  String get _rateText {
    final value = hourlyRate % 1 == 0
        ? hourlyRate.toInt().toString()
        : hourlyRate.toStringAsFixed(2);
    return 'QAR $value / hour';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            Color.lerp(AppColors.primary, AppColors.white, 0.22)!,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          // Extra bottom padding leaves room for the floating stats card.
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 64),
          child: Column(
            children: [
              _TitleBar(onEditProfile: onEditProfile),
              const SizedBox(height: 16),
              _Avatar(initial: _initial),
              const SizedBox(height: 14),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              _RatePill(text: _rateText),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.onEditProfile});

  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Balances the edit button so the title stays centered.
        const SizedBox(width: 48),
        const Expanded(
          child: Text(
            'My Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: onEditProfile,
          tooltip: 'Edit profile',
          icon: const Icon(Icons.edit_outlined, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: ProfileHeader._glass,
            fixedSize: const Size(44, 44),
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
      ),
      child: CircleAvatar(
        radius: 44,
        backgroundColor: AppColors.primaryLight,
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _RatePill extends StatelessWidget {
  const _RatePill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: ProfileHeader._glass,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.payments_outlined,
            size: 16,
            color: AppColors.white,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}