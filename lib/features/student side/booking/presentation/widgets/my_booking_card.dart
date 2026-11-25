import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_booking_entity.dart';
import 'booking_status_badge.dart';
import 'student_booking_ui.dart';

class MyBookingCard extends StatelessWidget {
  const MyBookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onCancel,
    this.isCancelling = false,
  });

  final StudentBookingEntity booking;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final bool isCancelling;

  /// Only pending and confirmed bookings can be cancelled.
  bool get _canCancel =>
      onCancel != null &&
          (booking.statusUi == MyBookingStatus.pending ||
              booking.statusUi == MyBookingStatus.confirmed);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(booking: booking),
              const SizedBox(height: 12),
              _MetaRow(booking: booking),
              const Divider(height: 22, color: AppColors.border),
              _PriceRow(price: booking.priceLabel),
              if (_canCancel) ...[
                const SizedBox(height: 12),
                _CancelButton(
                  onPressed: onCancel!,
                  isLoading: isCancelling,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.booking});

  final StudentBookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.subject,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'with ${booking.teacherName}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        BookingStatusBadge(status: booking.statusUi),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.booking});

  final StudentBookingEntity booking;

  @override
  Widget build(BuildContext context) {
    final isOnline = booking.mode.toLowerCase() == 'online';
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        _Meta(icon: Icons.calendar_today_outlined, text: booking.dateLabel),
        _Meta(icon: Icons.access_time_rounded, text: booking.timeLabel),
        _Meta(
          icon: isOnline ? Icons.videocam_outlined : Icons.place_outlined,
          text: booking.mode,
        ),
      ],
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Total price',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onPressed, required this.isLoading});

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          side: BorderSide(color: AppColors.red.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.red,
          ),
        )
            : const Text('Cancel booking'),
      ),
    );
  }
}