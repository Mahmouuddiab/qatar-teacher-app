import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/params/create_booking_params.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/core/widgets/app_snackbar.dart';
import 'package:qatar_teachers/features/student%20side/home/domain/entities/student_course_entity.dart';
import '../providers/student_booking_providers.dart';

Future<void> showBookCourseSheet(
    BuildContext context,
    StudentCourseEntity course,
    ) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BookCourseSheet(course: course),
  );
}

class BookCourseSheet extends ConsumerStatefulWidget {
  const BookCourseSheet({super.key, required this.course});

  final StudentCourseEntity course;

  @override
  ConsumerState<BookCourseSheet> createState() => _BookCourseSheetState();
}

class _BookCourseSheetState extends ConsumerState<BookCourseSheet> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  DateTime? _date;
  TimeOfDay? _time;
  late String _mode;
  String? _inlineError;

  late final List<String> _modes =
  widget.course.sessionMode.toLowerCase() == 'both'
      ? const ['Online', 'InPerson']
      : [widget.course.sessionMode];

  @override
  void initState() {
    super.initState();
    _mode = _modes.first;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
    );
    if (picked != null && mounted) {
      setState(() {
        _date = picked;
        _inlineError = null;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null && mounted) {
      setState(() {
        _time = picked;
        _inlineError = null;
      });
    }
  }

  Future<void> _submit() async {
    if (_date == null || _time == null) {
      setState(() => _inlineError = 'Choose a date and a time');
      return;
    }
    final when = DateTime(
      _date!.year, _date!.month, _date!.day, _time!.hour, _time!.minute,
    );
    if (!when.isAfter(DateTime.now())) {
      setState(() => _inlineError = 'Choose a time in the future');
      return;
    }
    setState(() => _inlineError = null);

    final result = await ref.read(createBookingProvider.notifier).create(
      CreateBookingParams(
        courseId: widget.course.id,
        sessionDate: when,
        mode: _mode,
      ),
    );
    if (!mounted) return;

    // Failure: show it inside the sheet (a snackbar would be hidden behind it)
    // so the user can pick another time right away.
    if (result.error != null) {
      setState(() => _inlineError = result.error);
      return;
    }
    if (result.booking == null) {
      setState(() => _inlineError = 'Booking failed. Please try again.');
      return;
    }

    // Success: close the sheet, then show the snackbar on the screen below.
    Navigator.pop(context);
    AppSnackBar.success('Request sent. Waiting for the teacher to confirm.');
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(createBookingProvider);
    final c = widget.course;
    final price = c.pricePerSessionQAR == c.pricePerSessionQAR.roundToDouble()
        ? c.pricePerSessionQAR.toInt().toString()
        : c.pricePerSessionQAR.toStringAsFixed(2);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20, 12, 20, 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              c.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'with ${c.teacherName}  •  ${c.durationMinutes} min',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _PickerTile(
                    icon: Icons.calendar_today_outlined,
                    label: _date == null
                        ? 'Date'
                        : '${_date!.day} ${_months[_date!.month - 1]} ${_date!.year}',
                    filled: _date != null,
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerTile(
                    icon: Icons.access_time_rounded,
                    label: _time == null ? 'Time' : _time!.format(context),
                    filled: _time != null,
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Session mode',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final m in _modes)
                  ChoiceChip(
                    label: Text(m),
                    selected: _mode == m,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                    labelStyle: TextStyle(
                      color: _mode == m ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() {
                      _mode = m;
                      _inlineError = null;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Total price',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                Text(
                  'QAR $price',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            if (_inlineError != null) ...[
              const SizedBox(height: 12),
              Text(
                _inlineError!,
                style: const TextStyle(color: AppColors.red),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: busy ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: busy
                    ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text('Request booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.icon,
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: filled
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}