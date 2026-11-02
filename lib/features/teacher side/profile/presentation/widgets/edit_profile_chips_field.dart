import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';


class EditProfileChipsField extends StatefulWidget {
  const EditProfileChipsField({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hint,
    this.errorText,
    this.enabled = true,
  });

  final List<String> items;
  final ValueChanged<List<String>> onChanged;
  final String hint;
  final String? errorText;
  final bool enabled;

  @override
  State<EditProfileChipsField> createState() => _EditProfileChipsFieldState();
}

class _EditProfileChipsFieldState extends State<EditProfileChipsField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;

    final exists = widget.items.any(
          (item) => item.toLowerCase() == value.toLowerCase(),
    );
    if (!exists) {
      widget.onChanged([...widget.items, value]);
    }
    _controller.clear();
  }

  void _remove(String item) {
    widget.onChanged(widget.items.where((e) => e != item).toList());
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _add(),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              onPressed: widget.enabled ? _add : null,
              icon: const Icon(Icons.add_circle_rounded),
              color: AppColors.primary,
              tooltip: 'Add',
            ),
            border: _border(hasError ? AppColors.red : AppColors.border),
            enabledBorder: _border(hasError ? AppColors.red : AppColors.border),
            focusedBorder: _border(hasError ? AppColors.red : AppColors.primary),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(fontSize: 12, color: AppColors.red),
            ),
          ),
        if (widget.items.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.items
                .map(
                  (item) => InputChip(
                label: Text(item),
                onDeleted: widget.enabled ? () => _remove(item) : null,
                backgroundColor: AppColors.primaryLight,
                deleteIconColor: AppColors.primary,
                side: BorderSide.none,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
                .toList(),
          ),
        ],
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );
  }
}
