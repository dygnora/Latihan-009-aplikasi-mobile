import 'package:flutter/material.dart';
import 'package:latihan_009_aplikasi_mobile/theme_controller.dart';

/// Halaman yang dibuka ketika notifikasi di-klik.
class NotificationDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const NotificationDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final imageUrl = data['image']?.toString().trim();

    // Pisahkan title, body, & image dari data tambahan
    final extraData = Map<String, dynamic>.from(data)
      ..remove('title')
      ..remove('body')
      ..remove('image');

    final cardColor = Theme.of(context).cardTheme.color ??
        (isDark ? const Color(0xFF1E1B16) : Colors.white);
    final accentColor = isDark ? Colors.amber.shade300 : Colors.amber.shade800;
    final softBgColor =
        isDark ? Colors.amber.shade900.withAlpha(70) : Colors.amber.shade50;
    final iconCircleColor =
        isDark ? Colors.amber.shade900.withAlpha(110) : Colors.amber.shade100;
    final borderColor =
        isDark ? Colors.amber.shade800.withAlpha(120) : Colors.amber.shade200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Notifikasi'),
        centerTitle: true,
        actions: const [ThemeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: borderColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    _NotificationImagePreview(imageUrl: imageUrl)
                  else
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: iconCircleColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        size: 56,
                        color: accentColor,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: softBgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.amber.shade700
                            : Colors.amber.shade300,
                      ),
                    ),
                    child: Text(
                      'NOTIFIKASI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: isDark
                            ? Colors.amber.shade200
                            : Colors.amber.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data['title']?.toString() ?? '-',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['body']?.toString() ?? '-',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.data_object, size: 20, color: accentColor),
              const SizedBox(width: 8),
              const Text(
                'Data Tambahan (Payload)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (extraData.isEmpty)
            Card(
              elevation: 0,
              color: softBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: borderColor),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Tidak ada data tambahan.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ...extraData.entries.map(
            (e) => Card(
              elevation: 1,
              color: cardColor,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isDark
                      ? Colors.amber.shade900.withAlpha(110)
                      : Colors.amber.shade100,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: iconCircleColor,
                  child: Icon(
                    Icons.label_outline,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                title: Text(
                  e.key,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                ),
                subtitle: Text(
                  e.value?.toString() ?? '-',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
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
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.red.shade900.withAlpha(70)
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Gambar gagal dimuat (pastikan URL mengarah langsung ke file gambar).',
                style: TextStyle(
                  color: isDark ? Colors.red.shade200 : Colors.red.shade900,
                ),
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


