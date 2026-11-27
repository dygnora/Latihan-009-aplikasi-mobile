import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latihan_009_aplikasi_mobile/fcm_token_card.dart';

class UserInfoScreen extends StatelessWidget {
  final User user;

  const UserInfoScreen({super.key, required this.user});

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard User'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ), // IconButton
        ],
      ), // AppBar
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              user.photoURL != null && user.photoURL!.isNotEmpty
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.photoURL!),
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.amber.shade700,
                    ),
              const SizedBox(height: 24),
              const Text(
                'Login Berhasil!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ), // Text
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UID: ${user.uid}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ), // Text
                      const SizedBox(height: 8),
                      Text(
                        'Display Name: ${user.displayName ?? "Tidak ada display name"}',
                      ),
                      const SizedBox(height: 8),
                      Text('Email: ${user.email ?? "Tidak ada email"}'),
                      const SizedBox(height: 8),
                      Text(
                        'Photo URL: ${user.photoURL ?? "Tidak ada photo URL"}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Email Terverifikasi: ${user.emailVerified ? "Ya" : "Tidak"}',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Terakhir Login: ${user.metadata.lastSignInTime?.toString() ?? "-"}',
                      ),
                    ],
                  ), // Column
                ), // Padding
              ), // Card
              const SizedBox(height: 16),
              const FcmTokenCard(),
            ],
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ); // Scaffold
  }
}
