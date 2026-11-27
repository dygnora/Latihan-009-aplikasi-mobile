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
            _NotificationImagePreview(imageUrl: imageUrl)
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

/// Preview gambar notifikasi tanpa memotong rasio aspek dan dapat diklik untuk zoom.
class _NotificationImagePreview extends StatelessWidget {
  final String imageUrl;

  const _NotificationImagePreview({required this.imageUrl});

  void _openZoomPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ImageZoomPage(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 320),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (frame == null && !wasSynchronouslyLoaded) return child;
            return GestureDetector(
              onTap: () => _openZoomPage(context),
              child: Stack(
                children: [
                  Hero(
                    tag: 'notif-image-$imageUrl',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: child,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.zoom_in,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Gambar gagal dimuat (pastikan URL mengarah langsung ke file gambar).',
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Halaman fullscreen untuk zoom & geser gambar notifikasi.
class _ImageZoomPage extends StatefulWidget {
  final String imageUrl;

  const _ImageZoomPage({required this.imageUrl});

  @override
  State<_ImageZoomPage> createState() => _ImageZoomPageState();
}

class _ImageZoomPageState extends State<_ImageZoomPage> {
  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    final isZoomed = _controller.value != Matrix4.identity();
    setState(() {
      _controller.value = isZoomed
          ? Matrix4.identity()
          : (Matrix4.identity()..scaleByDouble(2.0, 2.0, 1.0, 1.0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onDoubleTap: _toggleZoom,
        child: InteractiveViewer(
          transformationController: _controller,
          minScale: 0.8,
          maxScale: 4.0,
          child: Center(
            child: Hero(
              tag: 'notif-image-${widget.imageUrl}',
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Gambar gagal dimuat.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


