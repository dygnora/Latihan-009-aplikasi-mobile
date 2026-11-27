import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:latihan_009_aplikasi_mobile/notification_service.dart';
import 'package:latihan_009_aplikasi_mobile/theme_controller.dart';

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
  const MyApp({super.key});

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryAmber = isDark ? Colors.amber.shade400 : Colors.amber.shade700;

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amber,
        brightness: brightness,
        primary: primaryAmber,
        secondary: isDark ? Colors.amber.shade300 : Colors.amber.shade600,
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF14120E)
          : const Color(0xFFFFFBF2),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? const Color(0xFF1F1A12) : Colors.amber,
        foregroundColor: isDark ? Colors.amber.shade300 : Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1E1B16) : Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryAmber,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Firebase Auth Simple',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          themeMode: themeMode,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          // Menggunakan StreamBuilder untuk mendeteksi status login
          home: const AuthWrapper(),
        );
      },
    );
  }
}