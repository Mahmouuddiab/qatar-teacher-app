import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/core/widgets/app_snackbar.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';
import '../providers/student_booking_providers.dart';
import '../widgets/my_booking_card.dart';
import '../widgets/my_bookings_empty_view.dart';
import '../widgets/my_bookings_error_view.dart';
import '../widgets/my_bookings_filter_bar.dart';
import '../widgets/student_booking_ui.dart';

class StudentBookingScreen extends ConsumerStatefulWidget {
  const StudentBookingScreen({super.key});

  @override
  ConsumerState<StudentBookingScreen> createState() =>
      _StudentBookingScreenState();
}

class _StudentBookingScreenState extends ConsumerState<StudentBookingScreen> {
  // Space for the floating bottom nav bar
  static const double _bottomSpace = 120;

  MyBookingFilter _filter = MyBookingFilter.all;

  Future<void> _refresh() async {
    ref.invalidate(myBookingsProvider);
    await ref.read(myBookingsProvider.future).then((_) {}, onError: (_) {});
  }

  Future<void> _cancel(StudentBookingEntity b) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel booking?'),
        content: Text(
          'Your session "${b.subject}" with ${b.teacherName} on '
              '${b.dateLabel} at ${b.timeLabel} will be cancelled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep it'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final error = await ref.read(cancelBookingProvider.notifier).cancel(b.id);
    if (!mounted) return;
    if (error != null) {
      AppSnackBar.error(error);
    } else {
      AppSnackBar.success('Booking cancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(myBookingsProvider);
    final cancelling = ref.watch(cancelBookingProvider);

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
            'My Bookings',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        body: async.when(
          skipLoadingOnReload: true,
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => MyBookingsErrorView(
            message: e is Failure ? e.message : 'Failed to load bookings',
            onRetry: () => ref.invalidate(myBookingsProvider),
          ),
          data: (bookings) {
            final counts = {
              for (final f in MyBookingFilter.values)
                f: bookings.where((b) => f.matches(b.statusUi)).length,
            };
            final visible =
            bookings.where((b) => _filter.matches(b.statusUi)).toList();

            return Column(
              children: [
                const SizedBox(height: 4),
                MyBookingsFilterBar(
                  selected: _filter,
                  counts: counts,
                  onSelected: (f) => setState(() => _filter = f),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _refresh,
                    child: visible.isEmpty
                        ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [MyBookingsEmptyView(filter: _filter)],
                    )
                        : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        _bottomSpace,
                      ),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final booking = visible[i];
                        return MyBookingCard(
                          booking: booking,
                          isCancelling: cancelling.contains(booking.id),
                          onCancel: () => _cancel(booking),
                          onTap: () {}, // TODO: student booking details
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}