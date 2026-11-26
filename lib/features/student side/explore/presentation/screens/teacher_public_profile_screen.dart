import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../widgets/explore_ui_models.dart';

class TeacherPublicProfileScreen extends StatelessWidget {
  const TeacherPublicProfileScreen({super.key, required this.teacher});

  final TeacherUi teacher;

  @override
  Widget build(BuildContext context) {
    final t = teacher;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Teacher Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Card(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    t.name.isEmpty ? '?' : t.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _Stat(
                      icon: Icons.star_rounded,
                      iconColor: AppColors.ratingStar,
                      value: t.rating.toString(),
                      label: 'Rating',
                    ),
                    const _VerticalLine(),
                    _Stat(
                      icon: Icons.workspace_premium_outlined,
                      iconColor: AppColors.primary,
                      value: '${t.yearsOfExperience} yrs',
                      label: 'Experience',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'About',
            icon: Icons.info_outline_rounded,
            child: Text(t.bio, style: const TextStyle(height: 1.5)),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Qualifications',
            icon: Icons.school_outlined,
            child: Text(t.qualifications, style: const TextStyle(height: 1.5)),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Subjects',
            icon: Icons.menu_book_outlined,
            child: _Chips(items: t.subjects),
          ),
          const SizedBox(height: 12),
          _Section(
            title: 'Languages',
            icon: Icons.translate_rounded,
            child: _Chips(items: t.languages, outlined: true),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: iconColor),
              const SizedBox(width: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalLine extends StatelessWidget {
  const _VerticalLine();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 36, color: AppColors.border);
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips({required this.items, this.outlined = false});

  final List<String> items;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final s in items)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: outlined ? Colors.transparent : AppColors.primaryLight,
              border: outlined ? Border.all(color: AppColors.border) : null,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              s,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: outlined ? AppColors.textSecondary : AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
