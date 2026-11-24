
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FcmTokenCard extends StatefulWidget {
  const FcmTokenCard({super.key});

  @override
  State<FcmTokenCard> createState() => _FcmTokenCardState();
}

class _FcmTokenCardState extends State<FcmTokenCard> {
  String? token;
  bool isLoading = false;
  String? errorMessage;

  // Ganti dengan VAPID public key dari Firebase Console.
  static const String vapidKey = 'BHi2OBK_vzb_kxO387Y9bFoBf19WLNsFyZH5_VwmpV7ntT2jItQSdS7AH8QOh9Vo8TTVL8StMH6MtB2NuHqcysI';

  Future<void> getFcmToken() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final messaging = FirebaseMessaging.instance;

      // Meminta izin notifikasi.
      final settings = await messaging.requestPermission();

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        throw Exception('Izin notifikasi belum diberikan.');
      }

      // Web membutuhkan VAPID key.
      final fcmToken = await messaging.getToken(
        vapidKey: kIsWeb ? vapidKey : null,
      );

      if (fcmToken == null) {
        throw Exception('FCM Token tidak tersedia.');
      }

      setState(() {
        token = fcmToken;
      });

      debugPrint('FCM TOKEN: $fcmToken');
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });

      debugPrint('FCM ERROR: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> copyToken() async {
    if (token == null) return;

    await Clipboard.setData(ClipboardData(text: token!));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('FCM Token berhasil disalin!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FCM Token',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            if (isLoading)
              const Center(child: CircularProgressIndicator()),

            if (token != null && !isLoading)
              SelectableText(
                token!,
                style: const TextStyle(fontSize: 12),
              ),

            if (errorMessage != null)
              SelectableText(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: isLoading ? null : getFcmToken,
                  icon: const Icon(Icons.notifications),
                  label: const Text('Ambil FCM Token'),
                ),
                if (token != null)
                  ElevatedButton.icon(
                    onPressed: copyToken,
                    icon: const Icon(Icons.copy),
                    label: const Text('Salin Token'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
