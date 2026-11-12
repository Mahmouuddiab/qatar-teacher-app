import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../models/booking_ui_model.dart';
import '../widgets/booking_card.dart';
import '../widgets/bookings_empty_view.dart';
import '../widgets/bookings_filter_bar.dart';

class TeacherBookingScreen extends StatefulWidget {
  const TeacherBookingScreen({super.key});

  @override
  State<TeacherBookingScreen> createState() => _TeacherBookingsScreenState();
}

class _TeacherBookingsScreenState extends State<TeacherBookingScreen> {
  // Space for the floating bottom nav bar
  static const double _bottomSpace = 120;

  final List<BookingUiModel> _bookings = sampleBookings;
  BookingFilter _filter = BookingFilter.all;

  @override
  Widget build(BuildContext context) {
    final counts = {
      for (final f in BookingFilter.values)
        f: _bookings.where((b) => f.matches(b.status)).length,
    };
    final visible = _bookings.where((b) => _filter.matches(b.status)).toList();

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
        body: Column(
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
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, _bottomSpace),
                itemCount: visible.length,
                itemBuilder: (context, i) {
                  final booking = visible[i];
                  return BookingCard(
                    booking: booking,
                    onTap: () {}, // TODO: open booking details
                    onAccept: () {}, // TODO: PUT status
                    onReject: () {}, // TODO: PUT status
                    onComplete: () {}, // TODO: PUT complete
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}