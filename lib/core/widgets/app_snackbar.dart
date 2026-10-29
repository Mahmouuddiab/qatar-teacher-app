import 'package:flutter/material.dart';

enum SnackType { success, error, warning, info }

class AppSnackBar {
  AppSnackBar._();

  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void success(String message) => _show(message, SnackType.success);
  static void error(String message) => _show(message, SnackType.error);
  static void warning(String message) => _show(message, SnackType.warning);
  static void info(String message) => _show(message, SnackType.info);

  static void _show(
    String message,
    SnackType type, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    final style = _styleOf(type);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: duration,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: style.color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: style.color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(style.icon, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: messenger.hideCurrentSnackBar,
                  child: const Icon(
                    Icons.close,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  static _SnackStyle _styleOf(SnackType type) {
    switch (type) {
      case SnackType.success:
        return const _SnackStyle(Color(0xFF2E9E5B), Icons.check_circle_outline);
      case SnackType.error:
        return const _SnackStyle(Color(0xFFD64545), Icons.error_outline);
      case SnackType.warning:
        return const _SnackStyle(
          Color(0xFFE59A1F),
          Icons.warning_amber_rounded,
        );
      case SnackType.info:
        return const _SnackStyle(Color(0xFF3B7DDD), Icons.info_outline);
    }
  }
}

class _SnackStyle {
  final Color color;
  final IconData icon;
  const _SnackStyle(this.color, this.icon);
}
