import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  LocalNotificationsService._();

  static final LocalNotificationsService instance =
  LocalNotificationsService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'Important notifications',
    description: 'Booking requests and updates',
    importance: Importance.high,
  );

  void Function(Map<String, dynamic> data)? onTap;

  Future<void> init() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    // Required on Android 13 and newer.
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    // Required on iOS.
    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final decodedPayload = jsonDecode(payload);

      if (decodedPayload is Map) {
        onTap?.call(
          Map<String, dynamic>.from(decodedPayload),
        );
      }
    } catch (error) {
      debugPrint('Invalid notification payload: $error');
    }
  }

  Future<void> show({
    required String title,
    required String body,
    Map<String, dynamic> data = const {},
  }) async {
    final notificationId =
    DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);

    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'Important notifications',
        channelDescription: 'Booking requests and updates',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: jsonEncode(data),
    );
  }
}