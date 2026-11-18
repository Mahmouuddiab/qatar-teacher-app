import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../domain/entities/booking_entity.dart';
import '../models/booking_ui_model.dart';
import '../providers/teacher_booking_providers.dart';
import '../widgets/booking_actions.dart';
import '../widgets/booking_actions_widget.dart';

class TeacherBookingDetailsScreen extends ConsumerWidget {
  final int bookingId;
  const TeacherBookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingDetailsProvider(bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Booking Details',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: bookingAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                  'Failed to load booking',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  onPressed: () =>
                      ref.invalidate(bookingDetailsProvider(bookingId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (booking) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(bookingDetailsProvider(bookingId));
            await ref
                .read(bookingDetailsProvider(bookingId).future)
                .then((_) {}, onError: (_) {});
          },
          child: _Body(booking: booking),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  final BookingEntity booking;
  const _Body({required this.booking});

  Color _statusColor(BookingStatus s) => switch (s) {
    BookingStatus.pending => AppColors.ratingStar,
    BookingStatus.confirmed => AppColors.success,
    BookingStatus.completed => AppColors.primary,
    BookingStatus.cancelled => AppColors.red,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = ref.watch(bookingActionProvider);
    final ui = BookingUiModel.fromEntity(booking);
    final color = _statusColor(ui.status);
    final isOnline = booking.mode.toLowerCase() == 'online';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      booking.subject,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      ui.status.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Booking #${booking.id}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Card(
          child: Column(
            children: [
              _Row(
                icon: Icons.person_outline,
                label: 'Student',
                value: booking.studentName,
              ),
              const _Line(),
              _Row(
                icon: Icons.calendar_today_outlined,
                label: 'Date',
                value: ui.dateLabel,
              ),
              const _Line(),
              _Row(
                icon: Icons.access_time_rounded,
                label: 'Time',
                value: ui.timeLabel,
              ),
              const _Line(),
              _Row(
                icon: isOnline ? Icons.videocam_outlined : Icons.place_outlined,
                label: 'Mode',
                value: booking.mode,
              ),
              const _Line(),
              _Row(
                icon: Icons.payments_outlined,
                label: 'Total price',
                value: ui.price,
                highlight: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Same widget the list cards use
        AbsorbPointer(
          absorbing: busy,
          child: Opacity(
            opacity: busy ? 0.6 : 1,
            child: BookingActions(
              status: ui.status,
              onAccept: () =>
                  respondToBooking(context, ref, booking.id, accept: true),
              onReject: () =>
                  respondToBooking(context, ref, booking.id, accept: false),
              onComplete: () {}, // TODO: PUT complete
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

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

class _Row extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  const _Row({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: highlight ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) =>
      const Divider(height: 24, color: AppColors.border);
}
