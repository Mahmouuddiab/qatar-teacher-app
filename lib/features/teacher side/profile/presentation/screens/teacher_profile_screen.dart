import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/domain/entity/profile_entity.dart';
import '../providers/teacher_profile_providers.dart';
import '../widgets/profile_actions_section.dart';
import '../widgets/profile_chips_section.dart';
import '../widgets/profile_error_view.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_stats_row.dart';
import '../widgets/profile_text_section.dart';
import 'edit_teacher_profile_screen.dart';

class TeacherProfileScreen extends ConsumerWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(teacherProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => SafeArea(
          child: ProfileErrorView(
            message: error.toString().replaceFirst('Exception: ', ''),
            onRetry: () => ref.invalidate(teacherProfileProvider),
          ),
        ),
        data: (profile) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: RefreshIndicator(
            color: AppColors.primary,
            edgeOffset: 80,
            onRefresh: () async {
              ref.invalidate(teacherProfileProvider);
              await ref.read(teacherProfileProvider.future);
            },
            child: _ProfileContent(profile: profile),
          ),
        ),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.profile});

  final ProfileEntity profile;

  static const double _bottomSpace = 120;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _ProfileHero(profile: profile),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, _bottomSpace),
          child: Column(
            children: [
              ProfileTextSection(
                title: 'About',
                icon: Icons.info_outline_rounded,
                text: profile.bio,
              ),
              ProfileTextSection(
                title: 'Qualifications',
                icon: Icons.school_outlined,
                text: profile.qualifications,
              ),
              ProfileChipsSection(
                title: 'Subjects',
                icon: Icons.menu_book_outlined,
                items: profile.subjects,
              ),
              ProfileChipsSection(
                title: 'Languages',
                icon: Icons.translate_rounded,
                items: profile.languages,
              ),
              const SizedBox(height: 4),
              ProfileActionsSection(
                onEditProfile: () => _openEditProfile(context, profile),
                onSettings: () {},
                onLogout: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void _openEditProfile(BuildContext context, ProfileEntity profile) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditTeacherProfileScreen(profile: profile),
    ),
  );
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});

  final ProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    const overlap = ProfileStatsRow.height / 2;

    return Padding(
      padding: const EdgeInsets.only(bottom: overlap),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ProfileHeader(
            name: profile.name,
            hourlyRate: profile.hourlyRateQAR,
            onEditProfile: () => _openEditProfile(context, profile),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: -overlap,
            child: ProfileStatsRow(
              rating: profile.rating,
              yearsOfExperience: profile.yearsOfExperience,
              completedSessions: profile.completedSessions,
            ),
          ),
        ],
      ),
    );
  }
}
