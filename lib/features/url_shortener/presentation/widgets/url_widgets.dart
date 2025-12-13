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

class RivePlaceholder extends StatefulWidget {
  const RivePlaceholder({super.key});

  @override
  State<RivePlaceholder> createState() => _RivePlaceholderState();
}

class _RivePlaceholderState extends State<RivePlaceholder> {
  File? _file;
  RiveWidgetController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initRive();
  }

  Future<void> _initRive() async {
    try {
      final file = await File.asset('assets/rive/hero.riv', riveFactory: Factory.rive);
      if (mounted) {
        setState(() {
          _file = file;
          _controller = RiveWidgetController(_file!);
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Failed to load Rive file: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: _isInitialized && _controller != null
          ? RiveWidget(
              controller: _controller!,
              fit: Fit.contain,
            )
          : const SizedBox.shrink(),
    );
  }
}
