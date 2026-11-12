import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../domain/entity/availability_entity.dart';
import '../providers/add_availability_notifier.dart';
import '../providers/availability_providers.dart';

class AddAvailabilityScreen extends ConsumerStatefulWidget {
  const AddAvailabilityScreen({super.key});

  @override
  ConsumerState<AddAvailabilityScreen> createState() =>
      _AddAvailabilityScreenState();
}

class _AddAvailabilityScreenState extends ConsumerState<AddAvailabilityScreen> {
  static const _days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  bool _isRecurring = true;
  int _dayOfWeek = 0; // 0 = Sunday
  DateTime _date = DateTime.now();
  TimeOfDay _start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 10, minute: 0);

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  int _minutes(TimeOfDay t) => t.hour * 60 + t.minute;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: _pickerTheme,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
      builder: _pickerTheme,
    );
    if (picked == null) return;
    setState(() => isStart ? _start = picked : _end = picked);
  }

  Widget _pickerTheme(BuildContext context, Widget? child) => Theme(
    data: Theme.of(context).copyWith(
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
    ),
    child: child!,
  );

  void _showMessage(String text, {bool error = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? AppColors.red : AppColors.success,
        ),
      );
  }

  void _submit() {
    if (_minutes(_end) <= _minutes(_start)) {
      _showMessage('End time must be after start time', error: true);
      return;
    }

    ref.read(addAvailabilityProvider.notifier).submit(
      AvailabilityEntity(
        isRecurring: _isRecurring,
        dayOfWeek: _isRecurring ? _dayOfWeek : null,
        date: _isRecurring
            ? null
            : DateTime.utc(_date.year, _date.month, _date.day),
        startTime: _fmt(_start),
        endTime: _fmt(_end),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AddAvailabilityState>(addAvailabilityProvider, (prev, next) {
      if (next.status == AddAvailabilityStatus.success) {
        _showMessage('Availability added');
        Navigator.of(context).pop(next.created);
      } else if (next.status == AddAvailabilityStatus.failure) {
        _showMessage(next.errorMessage ?? 'Something went wrong', error: true);
      }
    });

    final isLoading = ref.watch(addAvailabilityProvider).isLoading;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Add Availability',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            _SectionCard(
              title: 'Type',
              icon: Icons.repeat_rounded,
              child: Row(
                children: [
                  Expanded(
                    child: _ChoiceButton(
                      label: 'Weekly',
                      selected: _isRecurring,
                      onTap: isLoading
                          ? null
                          : () => setState(() => _isRecurring = true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ChoiceButton(
                      label: 'One time',
                      selected: !_isRecurring,
                      onTap: isLoading
                          ? null
                          : () => setState(() => _isRecurring = false),
                    ),
                  ),
                ],
              ),
            ),
            if (_isRecurring)
              _SectionCard(
                title: 'Day',
                icon: Icons.calendar_view_week_rounded,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < _days.length; i++)
                      ChoiceChip(
                        label: Text(_days[i]),
                        selected: _dayOfWeek == i,
                        showCheckmark: false,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        side: BorderSide(
                          color: _dayOfWeek == i
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _dayOfWeek == i
                              ? AppColors.white
                              : AppColors.textPrimary,
                        ),
                        onSelected: isLoading
                            ? null
                            : (_) => setState(() => _dayOfWeek = i),
                      ),
                  ],
                ),
              )
            else
              _SectionCard(
                title: 'Date',
                icon: Icons.event_outlined,
                child: _ValueBox(
                  icon: Icons.calendar_today_rounded,
                  value:
                  '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                  onTap: isLoading ? null : _pickDate,
                ),
              ),
            _SectionCard(
              title: 'Time',
              icon: Icons.schedule_rounded,
              child: Row(
                children: [
                  Expanded(
                    child: _ValueBox(
                      label: 'From',
                      icon: Icons.access_time_rounded,
                      value: _start.format(context),
                      onTap: isLoading ? null : () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ValueBox(
                      label: 'To',
                      icon: Icons.access_time_filled_rounded,
                      value: _end.format(context),
                      onTap: isLoading ? null : () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.white,
                ),
              )
                  : const Text(
                'Save',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _ValueBox extends StatelessWidget {
  const _ValueBox({
    required this.icon,
    required this.value,
    required this.onTap,
    this.label,
  });

  final IconData icon;
  final String value;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null)
                    Text(
                      label!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}