
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'notification_detail_screen.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint('[FCM] Background: ${message.messageId}');
  debugPrint('[FCM] Data: ${message.data}');
}

class NotificationService {
  NotificationService._();

  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'Notifikasi Penting',
    description: 'Channel notifikasi FCM',
    importance: Importance.max,
  );

  static Future<void> init() async {
    // 1. Permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(
      '[FCM] Permission: ${settings.authorizationStatus}',
    );

    // 2. Token
    try {
      final token = await _messaging.getToken();
      debugPrint('[FCM] TOKEN: $token');
    } catch (e) {
      debugPrint('[FCM] Token error: $e');
    }

    _messaging.onTokenRefresh.listen((token) {
      debugPrint('[FCM] TOKEN BARU: $token');
    });

    // 3. Local notification khusus Android
    if (!kIsWeb) {
      const androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      await _localNotif.initialize(
        settings: const InitializationSettings(
          android: androidInit,
        ),
        onDidReceiveNotificationResponse: (response) {
          if (response.payload != null) {
            _openDetail(
              jsonDecode(response.payload!) as Map<String, dynamic>,
            );
          }
        },
      );

      await _localNotif
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_channel);

      // Cek local notification yang membuka aplikasi.
      final launchDetails =
          await _localNotif.getNotificationAppLaunchDetails();

      final payload =
          launchDetails?.notificationResponse?.payload;

      if ((launchDetails?.didNotificationLaunchApp ?? false) &&
          payload != null) {
        _openDetail(
          jsonDecode(payload) as Map<String, dynamic>,
        );
      }
    }

    // 4. Subscribe topic khusus Android.
    if (!kIsWeb) {
      try {
        await _messaging.subscribeToTopic('kelas');
      } catch (e) {
        debugPrint('[FCM] Subscribe topic error: $e');
      }
    }

    // 5. Foreground message.
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // 6. Klik notifikasi ketika aplikasi di background.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('[FCM] Notifikasi diklik dari background');
      _openDetail(_messageToMap(message));
    });
  }

  // Menampilkan local notification di Android.
  static Future<void> _showForegroundNotification(
    RemoteMessage message,
  ) async {
    debugPrint('[FCM] Foreground message');

    if (kIsWeb) {
      // Notifikasi Web ditangani oleh browser / Service Worker.
      return;
    }

    final notification = message.notification;
    if (notification == null) return;

    await _localNotif.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(_messageToMap(message)),
    );
  }

  static Map<String, dynamic> _messageToMap(
    RemoteMessage message,
  ) {
    return {
      'title': message.notification?.title ?? '-',
      'body': message.notification?.body ?? '-',
      ...message.data,
    };
  }

  static void _openDetail(Map<String, dynamic> data) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => NotificationDetailScreen(data: data),
      ),
    );
  }
}
