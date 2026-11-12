import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../providers/availability_providers.dart';
import '../widgets/availability_empty_view.dart';
import '../widgets/availability_error_view.dart';
import '../widgets/availability_slots_list.dart';
import 'add_availability_screen.dart';

class TeacherAvailabilityScreen extends ConsumerWidget {
  const TeacherAvailabilityScreen({super.key});

  static const double _bottomSpace = 120;

  Future<void> _openAdd(BuildContext context, WidgetRef ref) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddAvailabilityScreen()));
    ref.invalidate(availabilitiesProvider);
  }

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(availabilitiesProvider);
    try {
      await ref.read(availabilitiesProvider.future);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(availabilitiesProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'Availability',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          actions: [
            IconButton(
              tooltip: 'Add availability',
              onPressed: () => _openAdd(context, ref),
              icon: const Icon(Icons.add_rounded, size: 28),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: async.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, _) => AvailabilityErrorView(
            message: error.toString().replaceFirst('Exception: ', ''),
            onRetry: () => ref.invalidate(availabilitiesProvider),
          ),
          data: (slots) => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => _refresh(ref),
            child: slots.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 120),
                      AvailabilityEmptyView(),
                    ],
                  )
                : AvailabilitySlotsList(
                    slots: slots,
                    bottomSpace: _bottomSpace,
                  ),
          ),
        ),
      ),
    );
  }
}
