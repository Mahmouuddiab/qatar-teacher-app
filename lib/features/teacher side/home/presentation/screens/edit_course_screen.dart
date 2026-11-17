import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/params/update_course_params.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import '../../domain/entities/course_entity.dart';
import '../providers/teacher_home_providers.dart';

class EditCourseScreen extends ConsumerStatefulWidget {
  final CourseEntity course;
  const EditCourseScreen({super.key, required this.course});

  @override
  ConsumerState<EditCourseScreen> createState() => _EditCourseScreenState();
}

class _EditCourseScreenState extends ConsumerState<EditCourseScreen> {
  final _formKey = GlobalKey<FormState>();

  static const _levels = ['Beginner', 'Intermediate', 'Advanced'];
  static const _modes = ['Online', 'InPerson', 'Both'];

  late final TextEditingController _title;
  late final TextEditingController _subject;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _duration;
  late String _level;
  late String _mode;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final c = widget.course;
    _title = TextEditingController(text: c.title);
    _subject = TextEditingController(text: c.subject);
    _description = TextEditingController(text: c.description);
    _price = TextEditingController(text: c.pricePerSessionQAR.toString());
    _duration = TextEditingController(text: c.durationMinutes.toString());
    _level = _levels.contains(c.level) ? c.level : _levels.first;
    _mode = _modes.contains(c.sessionMode) ? c.sessionMode : _modes.first;
    _isActive = c.isActive;
  }

  @override
  void dispose() {
    _title.dispose();
    _subject.dispose();
    _description.dispose();
    _price.dispose();
    _duration.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(updateCourseProvider.notifier)
        .updateCourse(
          UpdateCourseParams(
            id: widget.course.id,
            title: _title.text.trim(),
            subject: _subject.text.trim(),
            description: _description.text.trim(),
            level: _level,
            pricePerSessionQAR: num.parse(_price.text.trim()),
            durationMinutes: int.parse(_duration.text.trim()),
            sessionMode: _mode,
            isActive: _isActive,
          ),
        );
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  );

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateCourseProvider);

    ref.listen<UpdateCourseState>(updateCourseProvider, (prev, next) {
      if (next.status == UpdateCourseStatus.success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Course updated')));
        Navigator.pop(context);
      } else if (next.status == UpdateCourseStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Update failed')),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Edit Course',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: _decoration('Title'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _subject,
              decoration: _decoration('Subject'),
              validator: _required,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _description,
              decoration: _decoration('Description'),
              maxLines: 4,
              validator: _required,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _level,
              decoration: _decoration('Level'),
              items: _levels
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _level = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _mode,
              decoration: _decoration('Session mode'),
              items: _modes
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _mode = v!),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _price,
                    decoration: _decoration('Price (QAR)'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (v) {
                      final n = num.tryParse(v?.trim() ?? '');
                      return (n == null || n <= 0) ? 'Invalid price' : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _duration,
                    decoration: _decoration('Duration (min)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final n = int.tryParse(v?.trim() ?? '');
                      return (n == null || n <= 0) ? 'Invalid duration' : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Material(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: AppColors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                activeColor: AppColors.primary,
                title: const Text('Active'),
                subtitle: const Text("Inactive courses can't be booked"),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: state.isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
