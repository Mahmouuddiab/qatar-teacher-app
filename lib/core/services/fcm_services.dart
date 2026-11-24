import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qatar_teachers/core/network/api_constant.dart';
import 'package:qatar_teachers/core/network/dio_helper.dart';
import 'package:qatar_teachers/core/services/local_notifications_service.dart';

import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint(
      'Background FCM message received: ${message.messageId}',
    );

    debugPrint('Background message data: ${message.data}');
  } catch (error) {
    debugPrint('Background FCM error: $error');
  }
}

class FcmService {
  FcmService._();

  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  ProviderContainer? _container;

  Future<void> init(ProviderContainer container) async {
    _container = container;

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    await _requestPermission();

    await LocalNotificationsService.instance.init();

    LocalNotificationsService.instance.onTap = _handleLocalNotificationTap;

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(
      _handleMessageOpenedApp,
    );

    final initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    debugPrint('FCM service initialized');
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
      'FCM permission status: ${settings.authorizationStatus}',
    );
  }

  Future<void> registerToken() async {
    try {
      final token = await _messaging.getToken();

      if (token == null || token.isEmpty) {
        debugPrint('FCM token is null or empty');
        return;
      }

      final platform = _getPlatformName();

      debugPrint('Registering FCM token for platform: $platform');

      await _sendTokenToBackend(
        token: token,
        platform: platform,
      );

      _messaging.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM token refreshed');

        await _sendTokenToBackend(
          token: newToken,
          platform: platform,
        );
      });
    } catch (error, stackTrace) {
      debugPrint('FCM token registration failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  String _getPlatformName() {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ios';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'android';
    }

    return defaultTargetPlatform.name;
  }

  Future<void> _sendTokenToBackend({
    required String token,
    required String platform,
  }) async {
    await DioHelper.post(
      path: ApiConstants.registerDeviceToken,
      withAuth: true,
      data: {
        'token': token,
        'platform': platform,
      },
    );

    debugPrint('FCM token registered successfully on backend');
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground FCM message: ${message.messageId}');
    debugPrint('Foreground FCM data: ${message.data}');

    final notification = message.notification;

    final title = notification?.title ??
        message.data['title']?.toString() ??
        'New notification';

    final body = notification?.body ??
        message.data['body']?.toString() ??
        '';

    if (body.isEmpty && notification == null) {
      return;
    }

    await LocalNotificationsService.instance.show(
      title: title,
      body: body,
      data: message.data,
    );
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('Notification opened: ${message.messageId}');
    debugPrint('Opened notification data: ${message.data}');

    _openScreenFromNotification(message.data);
  }

  void _handleLocalNotificationTap(Map<String, dynamic> data) {
    debugPrint('Local notification tapped: $data');

    _openScreenFromNotification(data);
  }

  void _openScreenFromNotification(Map<String, dynamic> data) {
    final context = navigatorKey.currentState?.overlay?.context;

    if (context == null) {
      debugPrint('Navigator is not ready yet');
      return;
    }

    /*
     * Add your notification navigation here.
     *
     * Example:
     *
     * final bookingId = data['booking_id'];
     *
     * if (bookingId != null) {
     *   navigatorKey.currentState?.pushNamed(
     *     AppRoutes.bookingDetails,
     *     arguments: bookingId,
     *   );
     * }
     */
  }
}