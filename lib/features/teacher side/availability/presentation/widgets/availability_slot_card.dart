import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/core/utils/availability_formatters.dart';
import '../../domain/entity/availability_entity.dart';
import '../providers/availability_providers.dart';
import 'availability_status_badge.dart';
import 'delete_availability_dialog.dart';

class AvailabilitySlotCard extends ConsumerWidget {
  const AvailabilitySlotCard({super.key, required this.slot});

  final AvailabilityEntity slot;

  Future<void> _onDelete(BuildContext context, WidgetRef ref) async {
    // Grab the messenger first: the card may be gone after the list refreshes.
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDeleteAvailabilityDialog(
      context,
      isRecurring: slot.isRecurring,
    );
    if (!confirmed) return;

    final error =
    await ref.read(deleteAvailabilityProvider.notifier).delete(slot.id!);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(error ?? 'Availability deleted'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error == null ? AppColors.success : AppColors.red,
        ),
      );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeleting = ref.watch(deleteAvailabilityProvider).contains(slot.id);
    final canDelete = !slot.isBooked && slot.id != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _LeadingIcon(isRecurring: slot.isRecurring),
          const SizedBox(width: 12),
          Expanded(child: _Info(slot: slot)),
          AvailabilityStatusBadge(isBooked: slot.isBooked),
          if (isDeleting)
            const Padding(
              padding: EdgeInsets.only(left: 12, right: 4),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: AppColors.red,
                ),
              ),
            )
          else if (canDelete)
            IconButton(
              tooltip: 'Delete',
              visualDensity: VisualDensity.compact,
              onPressed: () => _onDelete(context, ref),
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.red,
                size: 22,
              ),
            ),
        ],
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({required this.isRecurring});

  final bool isRecurring;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isRecurring ? Icons.repeat_rounded : Icons.event_outlined,
        size: 22,
        color: AppColors.primary,
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.slot});

  final AvailabilityEntity slot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AvailabilityFormatters.title(slot),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              AvailabilityFormatters.timeRange(slot),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}