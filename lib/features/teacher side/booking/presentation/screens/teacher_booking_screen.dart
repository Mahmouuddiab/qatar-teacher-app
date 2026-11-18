import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../models/booking_ui_model.dart';
import '../providers/teacher_booking_providers.dart';
import '../widgets/booking_actions_widget.dart';
import '../widgets/booking_card.dart';
import '../widgets/bookings_empty_view.dart';
import '../widgets/bookings_filter_bar.dart';

class TeacherBookingScreen extends ConsumerStatefulWidget {
  const TeacherBookingScreen({super.key});

  @override
  ConsumerState<TeacherBookingScreen> createState() =>
      _TeacherBookingsScreenState();
}

class _TeacherBookingsScreenState extends ConsumerState<TeacherBookingScreen> {
  // Space for the floating bottom nav bar
  static const double _bottomSpace = 120;

  BookingFilter _filter = BookingFilter.all;

  Future<void> _refresh() async {
    ref.invalidate(bookingsProvider);
    await ref.read(bookingsProvider.future).then((_) {}, onError: (_) {});
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsProvider);
    final busy = ref.watch(bookingActionProvider);

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
            'Bookings',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        body: bookingsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Failed to load bookings',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () => ref.invalidate(bookingsProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (entities) {
            final bookings = entities.map(BookingUiModel.fromEntity).toList();

            final counts = {
              for (final f in BookingFilter.values)
                f: bookings.where((b) => f.matches(b.status)).length,
            };
            final visible = bookings
                .where((b) => _filter.matches(b.status))
                .toList();

            return Column(
              children: [
                const SizedBox(height: 4),
                BookingsFilterBar(
                  selected: _filter,
                  counts: counts,
                  onSelected: (f) => setState(() => _filter = f),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: visible.isEmpty
                      ? BookingsEmptyView(filter: _filter)
                      : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _refresh,
                    child: AbsorbPointer(
                      // Prevent double taps while a request is running
                      absorbing: busy,
                      child: Opacity(
                        opacity: busy ? 0.6 : 1,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            8,
                            16,
                            _bottomSpace,
                          ),
                          itemCount: visible.length,
                          itemBuilder: (context, i) {
                            final booking = visible[i];
                            return BookingCard(
                              booking: booking,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.teacherBookingDetails,
                                arguments: booking.id,
                              ),
                              onAccept: () => respondToBooking(
                                context,
                                ref,
                                booking.id,
                                accept: true,
                              ),
                              onReject: () => respondToBooking(
                                context,
                                ref,
                                booking.id,
                                accept: false,
                              ),
                              onComplete: () {}, // TODO: PUT complete
                            );
                          },
                        ),
                      ),
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