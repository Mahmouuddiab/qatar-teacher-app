import 'package:flutter/material.dart';
import 'package:qatar_teachers/core/utils/app_colors.dart';

class ExploreSearchBar extends StatefulWidget {
  const ExploreSearchBar({
    super.key,
    required this.onChanged,
    this.onSubmitted,
    this.initialValue = '',
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String initialValue;

  @override
  State<ExploreSearchBar> createState() => _ExploreSearchBarState();
}

class _ExploreSearchBarState extends State<ExploreSearchBar> {
  late final TextEditingController _controller =
  TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      onSubmitted: (v) {
        (widget.onSubmitted ?? widget.onChanged)(v);
        FocusScope.of(context).unfocus();
      },
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
      decoration: InputDecoration(
        hintText: 'Search courses',
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon:
        const Icon(Icons.search_rounded, color: AppColors.textSecondary),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (_, value, __) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
            icon: const Icon(Icons.close_rounded,
                size: 20, color: AppColors.textSecondary),
            onPressed: _clear,
          ),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}