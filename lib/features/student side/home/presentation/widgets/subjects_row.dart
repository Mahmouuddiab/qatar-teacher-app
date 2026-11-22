import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../providers/student_home_providers.dart';

IconData subjectIcon(String name) {
  final n = name.toLowerCase();
  if (n.contains('math')) return Icons.calculate_outlined;
  if (n.contains('phys')) return Icons.science_outlined;
  if (n.contains('chem')) return Icons.biotech_outlined;
  if (n.contains('bio')) return Icons.eco_outlined;
  if (n.contains('english') || n.contains('lang')) return Icons.translate_rounded;
  if (n.contains('arab')) return Icons.menu_book_outlined;
  if (n.contains('comput') || n.contains('program')) return Icons.code_rounded;
  return Icons.school_outlined;
}

class SubjectsRow extends ConsumerWidget {
  const SubjectsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(subjectsProvider);
    final selected = ref.watch(selectedSubjectProvider);
    final notifier = ref.read(selectedSubjectProvider.notifier);

    return SizedBox(
      height: 44,
      child: async.when(
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, __) => Container(
            width: 96,
            decoration: BoxDecoration(
              color: AppColors.border.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        error: (e, _) => Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            onPressed: () => ref.invalidate(subjectsProvider),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Couldn\'t load subjects. Retry'),
          ),
        ),
        data: (subjects) => ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: subjects.length + 1, // +1 for "All"
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final isAll = i == 0;
            final name = isAll ? 'All' : subjects[i - 1].name;
            final isSelected = isAll ? selected == null : selected == name;

            return _SubjectChip(
              label: name,
              icon: isAll ? Icons.apps_rounded : subjectIcon(name),
              selected: isSelected,
              onTap: () => notifier.select(isAll ? null : name),
            );
          },
        ),
      ),
    );
  }
}

class _SubjectChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _SubjectChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? Colors.white : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}