import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/params/update_teacher_profile.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';
import 'package:qatar_teachers/core/widgets/app_snackbar.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/domain/entity/profile_entity.dart';
import 'package:qatar_teachers/features/teacher%20side/profile/presentation/widgets/profile_section_card.dart';

import '../providers/edit_teacher_profile_providers.dart';
import '../widgets/edit_profile_chips_field.dart';
import '../widgets/edit_profile_save_button.dart';
import '../widgets/edit_profile_text_field.dart';

class EditTeacherProfileScreen extends ConsumerStatefulWidget {
  const EditTeacherProfileScreen({super.key, required this.profile});

  final ProfileEntity profile;

  @override
  ConsumerState<EditTeacherProfileScreen> createState() =>
      _EditTeacherProfileScreenState();
}

class _EditTeacherProfileScreenState
    extends ConsumerState<EditTeacherProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _hourlyRateController;
  late final TextEditingController _bioController;
  late final TextEditingController _qualificationsController;

  late List<String> _subjects;
  late List<String> _languages;

  String? _subjectsError;
  String? _languagesError;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _hourlyRateController = TextEditingController(
      text: p.hourlyRateQAR % 1 == 0
          ? p.hourlyRateQAR.toInt().toString()
          : p.hourlyRateQAR.toString(),
    );
    _bioController = TextEditingController(text: p.bio ?? '');
    _qualificationsController =
        TextEditingController(text: p.qualifications ?? '');

    _subjects = List<String>.of(p.subjects);
    _languages = List<String>.of(p.languages);
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    _bioController.dispose();
    _qualificationsController.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _onSave() async {
    final formValid = _formKey.currentState!.validate();

    setState(() {
      _subjectsError = _subjects.isEmpty ? 'Add at least one subject' : null;
      _languagesError = _languages.isEmpty ? 'Add at least one language' : null;
    });

    if (!formValid || _subjectsError != null || _languagesError != null) {
      return;
    }

    FocusScope.of(context).unfocus();

    final params = UpdateTeacherProfileParams(
      bio: _nullIfEmpty(_bioController.text),
      qualifications: _nullIfEmpty(_qualificationsController.text),
      hourlyRateQAR: double.parse(_hourlyRateController.text.trim()),
      subjects: _subjects,
      languages: _languages,
    );

    final success =
    await ref.read(editTeacherProfileProvider.notifier).save(params);

    if (!mounted) return;

    if (success) {
      AppSnackBar.success('Profile updated successfully');
      Navigator.pop(context);
    } else {
      final error = ref.read(editTeacherProfileProvider).error;
      AppSnackBar.error(
        error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(editTeacherProfileProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProfileSectionCard(
              title: 'Hourly Rate',
              icon: Icons.payments_outlined,
              child: EditProfileTextField(
                controller: _hourlyRateController,
                label: 'Rate per hour (QAR)',
                hint: 'e.g. 250',
                enabled: !isSaving,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                validator: (v) {
                  final value = double.tryParse(v?.trim() ?? '');
                  if (value == null || value <= 0) {
                    return 'Enter a valid hourly rate';
                  }
                  return null;
                },
              ),
            ),
            ProfileSectionCard(
              title: 'About You',
              icon: Icons.info_outline_rounded,
              child: Column(
                children: [
                  EditProfileTextField(
                    controller: _bioController,
                    label: 'Bio',
                    hint: 'Tell students about yourself',
                    enabled: !isSaving,
                    maxLines: 4,
                    maxLength: 500,
                    keyboardType: TextInputType.multiline,
                  ),
                  EditProfileTextField(
                    controller: _qualificationsController,
                    label: 'Qualifications',
                    hint: 'Degrees, certificates...',
                    enabled: !isSaving,
                    maxLines: 3,
                    maxLength: 300,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
            ProfileSectionCard(
              title: 'Subjects',
              icon: Icons.menu_book_outlined,
              child: EditProfileChipsField(
                items: _subjects,
                hint: 'Add a subject',
                errorText: _subjectsError,
                enabled: !isSaving,
                onChanged: (items) => setState(() {
                  _subjects = items;
                  _subjectsError = null;
                }),
              ),
            ),
            ProfileSectionCard(
              title: 'Languages',
              icon: Icons.translate_rounded,
              child: EditProfileChipsField(
                items: _languages,
                hint: 'Add a language',
                errorText: _languagesError,
                enabled: !isSaving,
                onChanged: (items) => setState(() {
                  _languages = items;
                  _languagesError = null;
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: EditProfileSaveButton(
        isLoading: isSaving,
        onPressed: _onSave,
      ),
    );
  }
}