import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/router/app_routes.dart';
import 'package:qatar_teachers/features/student%20side/notifications/presentation/providers/student_notifications_providers.dart';
import 'package:qatar_teachers/features/teacher%20side/notifications/presentation/providers/teacher_notifications_providers.dart';
import 'local_notifications_service.dart';

/// Must be top-level. Runs in its own isolate when the app is in background.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // The system shows notifications that carry a "notification" payload.
}

class FcmService {
  FcmService._();
  static final instance = FcmService._();

  final navigatorKey = GlobalKey<NavigatorState>();
  final _messaging = FirebaseMessaging.instance;

  late ProviderContainer _container;

  /// Set this to send the token to your backend.
  Future<void> Function(String token)? onTokenReady;

  Future<void> init(ProviderContainer container) async {
    _container = container;

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await LocalNotificationsService.instance.init();
    LocalNotificationsService.instance.onTap = _navigate;

    await _requestPermission();

    // iOS: show the system banner while the app is open
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground: Android doesn't show it by itself, so show a local one
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // Tapped while the app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((m) => _navigate(m.data));

    _messaging.onTokenRefresh.listen(_sendToken);
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission();
    debugPrint('FCM permission: ${settings.authorizationStatus}');
  }

  /// Call after login, when the user has a session token.
  Future<void> registerToken() async {
    try {
      final apns = await _messaging.getAPNSToken();
      debugPrint('APNS token: $apns');
      final token = await _messaging.getToken();
      debugPrint('FCM token: $token');
      if (token != null) await _sendToken(token);
    } catch (e) {
      debugPrint('registerToken error: $e');
    }
  }

  /// Call on logout so this device stops receiving the old user's pushes.
  Future<void> unregister() async {
    await _messaging.deleteToken();
  }

  Future<void> _sendToken(String token) async {
    try {
      await onTokenReady?.call(token);
    } catch (e) {
      debugPrint('Failed to send FCM token: $e');
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    if (n != null) {
      LocalNotificationsService.instance.show(
        title: n.title ?? '',
        body: n.body ?? '',
        data: message.data,
      );
    }

    // Keep the bell badges and lists fresh
    _container.invalidate(unreadCountProvider);
    _container.invalidate(notificationsProvider);
    _container.invalidate(studentUnreadCountProvider);
    _container.invalidate(studentNotificationsProvider);
  }

  /// App opened from a terminated state by tapping a notification.
  /// Call this once the first screen is ready (see step 6).
  Future<void> handleInitialMessage() async {
    final message = await _messaging.getInitialMessage();
    if (message != null) _navigate(message.data);
  }

  void _navigate(Map<String, dynamic> data) {
    final nav = navigatorKey.currentState;
    if (nav == null) return;

    final type = data['type']?.toString();
    final bookingId = int.tryParse(data['bookingId']?.toString() ?? '');

    switch (type) {
      case 'BookingRequested': // teacher received a request
        if (bookingId != null) {
          nav.pushNamed(AppRoutes.teacherBookingDetails, arguments: bookingId);
        } else {
          nav.pushNamed(AppRoutes.teacherNotifications);
        }
      case 'BookingConfirmed': // student booking confirmed
      default:
        nav.pushNamed(AppRoutes.studentNotifications);
    }
  }
}