import 'package:flutter/material.dart';

/// Halaman yang dibuka ketika notifikasi di-klik.
class NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const NotificationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final imageUrl = data['image']?.toString().trim();

    // Pisahkan title, body, & image dari data tambahan
    final extraData = Map<String, dynamic>.from(data)
      ..remove('title')
      ..remove('body')
      ..remove('image');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Notifikasi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Gambar gagal dimuat (pastikan URL mengarah langsung ke file gambar).',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Icon(
              Icons.notifications_active,
              size: 80,
              color: Color.fromARGB(255, 54, 117, 190),
            ),
          const SizedBox(height: 16),
          Text(
            data['title']?.toString() ?? '-',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            data['body']?.toString() ?? '-',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const Divider(height: 32),
          const Text(
            'Data tambahan (data payload):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (extraData.isEmpty) const Text('Tidak ada data tambahan.'),
          ...extraData.entries.map(
            (e) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(e.key),
                subtitle: Text(e.value?.toString() ?? '-'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

