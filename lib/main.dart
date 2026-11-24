
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:latihan_009_aplikasi_mobile/notification_service.dart';

import 'auth/auth_wrapper.dart';
import 'firebase_options.dart';
import 'notification_detail_screen.dart';

RemoteMessage? initialMessage;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // Ambil pesan jika aplikasi dibuka melalui notifikasi.
  initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final message = initialMessage;

      if (message != null) {
        initialMessage = null;

        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => NotificationDetailScreen(
              data: {
                'title': message.notification?.title ?? '-',
                'body': message.notification?.body ?? '-',
                ...message.data,
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Simple',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
    );
  }
}
