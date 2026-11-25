import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latihan_009_aplikasi_mobile/notification_service.dart';

import 'auth/auth_wrapper.dart';
import 'firebase_options.dart';

import 'package:firebase_messaging/firebase_messaging.dart'; 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  // Inisialisasi menggunakan opsi yang di-generate sesuai platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());

  await NotificationService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Simple',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), // ThemeData
      // Menggunakan StreamBuilder untuk mendeteksi status login
      home: const AuthWrapper(),
    ); // MaterialApp
  }
}