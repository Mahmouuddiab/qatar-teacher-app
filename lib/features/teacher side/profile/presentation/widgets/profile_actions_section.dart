import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

/// Account actions: Edit Profile and Settings in one card, Logout in its own.
class ProfileActionsSection extends StatelessWidget {
  const ProfileActionsSection({
    super.key,
    required this.onEditProfile,
    required this.onSettings,
    required this.onLogout,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ActionsCard(
          children: [
            _ProfileMenuTile(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              onTap: onEditProfile,
            ),
            const _MenuDivider(),
            _ProfileMenuTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: onSettings,
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ActionsCard(
          children: [
            _ProfileMenuTile(
              icon: Icons.logout_rounded,
              title: 'Logout',
              onTap: onLogout,
              isDestructive: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Material (not Container) so the tap ripple is visible on the tiles.
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final accent = isDestructive ? AppColors.red : AppColors.primary;
    final badgeColor = isDestructive
        ? Color.lerp(AppColors.white, AppColors.red, 0.1)!
        : AppColors.primaryLight;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 22, color: accent),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.red : AppColors.textPrimary,
        ),
      ),
      trailing: isDestructive
          ? null
          : const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      color: AppColors.border,
    );
  }
}