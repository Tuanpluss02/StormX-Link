import 'package:flutter/material.dart';
import 'package:link/features/url_shortener/domain/entities/shortened_url.dart';
import 'package:rive/rive.dart';

class UrlListItem extends StatelessWidget {
  final ShortenedUrl url;
  final VoidCallback onDelete;
  final VoidCallback onCopy;
  final VoidCallback onShowQr;

  const UrlListItem({
    super.key,
    required this.url,
    required this.onDelete,
    required this.onCopy,
    required this.onShowQr,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(url.shortUrl),
        subtitle: Text(url.originalUrl),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             IconButton(
              icon: const Icon(Icons.qr_code),
              onPressed: onShowQr,
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: onCopy,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class RivePlaceholder extends StatelessWidget {
  const RivePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder for Rive animation
    // Ideally, load a .riv file from assets
    return const SizedBox(
      height: 200,
      width: double.infinity,
      child: Center(
        child: Text("Rive Animation Placeholder"),
        // Example: RiveAnimation.asset('assets/rive/animation.riv'),
      ),
    );
  }
}
