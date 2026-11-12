import 'package:flutter/material.dart';
import '../../domain/entity/availability_entity.dart';
import 'availability_section_title.dart';
import 'availability_slot_card.dart';

class AvailabilitySlotsList extends StatelessWidget {
  const AvailabilitySlotsList({
    super.key,
    required this.slots,
    required this.bottomSpace,
  });

  final List<AvailabilityEntity> slots;
  final double bottomSpace;

  @override
  Widget build(BuildContext context) {
    final weekly = slots.where((s) => s.isRecurring).toList()
      ..sort((a, b) {
        final byDay = (a.dayOfWeek ?? 0).compareTo(b.dayOfWeek ?? 0);
        return byDay != 0 ? byDay : a.startTime.compareTo(b.startTime);
      });

    final oneTime = slots.where((s) => !s.isRecurring).toList()
      ..sort((a, b) {
        final byDate = (a.date ?? DateTime(0)).compareTo(b.date ?? DateTime(0));
        return byDate != 0 ? byDate : a.startTime.compareTo(b.startTime);
      });

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 20, 16, bottomSpace),
      children: [
        if (weekly.isNotEmpty) ...[
          const AvailabilitySectionTitle('Weekly'),
          for (final s in weekly) AvailabilitySlotCard(slot: s),
        ],
        if (oneTime.isNotEmpty) ...[
          const AvailabilitySectionTitle('One time'),
          for (final s in oneTime) AvailabilitySlotCard(slot: s),
        ],
      ],
    );
  }
}