import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/params/add_course_params.dart';
import '../providers/teacher_home_providers.dart';
import '../widgets/course_dropdown_field.dart';
import '../widgets/course_text_field.dart';

class AddCourseScreen extends ConsumerStatefulWidget {
  const AddCourseScreen({super.key});

  @override
  ConsumerState<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends ConsumerState<AddCourseScreen> {
  // TODO: replace with AppColors.primary
  static const Color _primary = Color(0xFF5E1933);

  // TODO: confirm the allowed values for these in Swagger
  static const _levels = ['Beginner', 'Intermediate', 'Advanced'];
  static const _sessionModes = ['Online', 'InPerson', 'Both'];

  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();

  String? _level;
  String? _sessionMode;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _subjectCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  String? _positiveNumber(String? v, String message) {
    final n = num.tryParse(v?.trim() ?? '');
    return (n == null || n <= 0) ? message : null;
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(addCourseProvider.notifier)
        .addCourse(
          AddCourseParams(
            title: _titleCtrl.text.trim(),
            subject: _subjectCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            level: _level!,
            pricePerSessionQAR: num.parse(_priceCtrl.text.trim()),
            durationMinutes: int.parse(_durationCtrl.text.trim()),
            sessionMode: _sessionMode!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addCourseProvider);

    ref.listen<AddCourseState>(addCourseProvider, (prev, next) {
      if (next.status == AddCourseStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Course added successfully')),
        );
        Navigator.pop(context, true);
      } else if (next.status == AddCourseStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Failed to add course')),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: Colors.black87,
        title: const Text('Add Course'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              CourseTextField(
                controller: _titleCtrl,
                label: 'Title',
                hint: 'Mathematics for Beginners',
                validator: (v) => _required(v, 'Title is required'),
              ),
              const SizedBox(height: 16),
              CourseTextField(
                controller: _subjectCtrl,
                label: 'Subject',
                hint: 'Mathematics',
                validator: (v) => _required(v, 'Subject is required'),
              ),
              const SizedBox(height: 16),
              CourseTextField(
                controller: _descCtrl,
                label: 'Description',
                maxLines: 4,
                validator: (v) => _required(v, 'Description is required'),
              ),
              const SizedBox(height: 16),
              CourseDropdownField(
                label: 'Level',
                value: _level,
                items: _levels,
                onChanged: (v) => setState(() => _level = v),
                validator: (v) => v == null ? 'Select a level' : null,
              ),
              const SizedBox(height: 16),
              CourseTextField(
                controller: _priceCtrl,
                label: 'Price per session',
                suffixText: 'QAR',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (v) => _positiveNumber(v, 'Enter a valid price'),
              ),
              const SizedBox(height: 16),
              CourseTextField(
                controller: _durationCtrl,
                label: 'Duration',
                suffixText: 'minutes',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => _positiveNumber(v, 'Enter a valid duration'),
              ),
              const SizedBox(height: 16),
              CourseDropdownField(
                label: 'Session mode',
                value: _sessionMode,
                items: _sessionModes,
                onChanged: (v) => setState(() => _sessionMode = v),
                validator: (v) => v == null ? 'Select a session mode' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Add Course'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
