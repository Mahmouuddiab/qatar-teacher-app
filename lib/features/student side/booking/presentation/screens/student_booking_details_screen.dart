import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/error/failure.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../domain/entities/student_booking_details_entity.dart';
import '../providers/student_booking_providers.dart';
import '../widgets/booking_status_badge.dart';
import '../widgets/student_booking_ui.dart';

const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _date(DateTime d) =>
    '${_days[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';

String _time(DateTime d) {
  final p = d.hour >= 12 ? 'PM' : 'AM';
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  return '$h:${d.minute.toString().padLeft(2, '0')} $p';
}

String _price(num v) =>
    'QAR ${v == v.roundToDouble() ? v.toInt() : v.toStringAsFixed(2)}';

class StudentBookingDetailsScreen extends ConsumerWidget {
  const StudentBookingDetailsScreen({super.key, required this.bookingId});

  final int bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(studentBookingDetailsProvider(bookingId));

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
      body: async.when(
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
              Text(
                e is Failure ? e.message : 'Failed to load booking',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                onPressed: () =>
                    ref.invalidate(studentBookingDetailsProvider(bookingId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (b) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(studentBookingDetailsProvider(bookingId));
            await ref
                .read(studentBookingDetailsProvider(bookingId).future)
                .then((_) {}, onError: (_) {});
          },
          child: _Body(booking: b),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.booking});

  final StudentBookingDetailsEntity booking;

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final isOnline = b.mode.toLowerCase() == 'online';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      b.course.title.isEmpty ? b.subject : b.course.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BookingStatusBadge(status: MyBookingStatus.from(b.status)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Booking #${b.id}',
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
              _Row(Icons.calendar_today_outlined, 'Date', _date(b.sessionDate)),
              const _Line(),
              _Row(
                Icons.access_time_rounded,
                'Time',
                '${_time(b.sessionDate)} - ${_time(b.sessionEndDate)}',
              ),
              const _Line(),
              _Row(
                Icons.timer_outlined,
                'Duration',
                '${b.durationMinutes} min',
              ),
              const _Line(),
              _Row(
                isOnline ? Icons.videocam_outlined : Icons.place_outlined,
                'Mode',
                b.mode,
              ),
              const _Line(),
              _Row(
                Icons.payments_outlined,
                'Total price',
                _price(b.totalPriceQAR),
                highlight: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _TeacherCard(teacher: b.teacher),
        const SizedBox(height: 12),
        _CourseCard(course: b.course),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Requested on ${_date(b.createdAt)}, ${_time(b.createdAt)}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        // TODO: if (b.canCancel) show a Cancel button once the endpoint exists
        const SizedBox(height: 24),
      ],
    );
  }
}

class _TeacherCard extends StatelessWidget {
  const _TeacherCard({required this.teacher});

  final BookingTeacherEntity teacher;

  @override
  Widget build(BuildContext context) {
    final t = teacher;
    final initial = t.name.isEmpty ? '?' : t.name[0].toUpperCase();

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${t.yearsOfExperience} yr experience',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.star_rounded,
                size: 20,
                color: AppColors.ratingStar,
              ),
              const SizedBox(width: 2),
              Text(
                t.rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          if (t.bio.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(t.bio, style: const TextStyle(height: 1.4)),
          ],
          if (t.qualifications.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              t.qualifications,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
          if (t.subjects.isNotEmpty || t.languages.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final s in t.subjects) _Chip(s),
                for (final l in t.languages) _Chip(l, outlined: true),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final BookingCourseEntity course;

  @override
  Widget build(BuildContext context) {
    final c = course;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About the course',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [_Chip(c.subject), _Chip(c.level), _Chip(c.sessionMode)],
          ),
          if (c.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(c.description, style: const TextStyle(height: 1.4)),
          ],
          const SizedBox(height: 12),
          Text(
            '${_price(c.pricePerSessionQAR)} / session  •  ${c.durationMinutes} min',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text, {this.outlined = false});

  final String text;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : AppColors.primaryLight,
        border: outlined ? Border.all(color: AppColors.border) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: outlined ? AppColors.textSecondary : AppColors.primary,
        ),
      ),
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

class _Row extends StatelessWidget {
  const _Row(this.icon, this.label, this.value, {this.highlight = false});

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

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
