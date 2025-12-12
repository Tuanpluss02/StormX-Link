import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link/core/di/injection.dart';
import 'package:link/features/url_shortener/presentation/providers/url_provider.dart';
import 'package:link/features/url_shortener/presentation/widgets/url_widgets.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<UrlProvider>()..loadUrls(),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StormX Link'),
      ),
      body: Column(
        children: [
          const RivePlaceholder(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: const InputDecoration(
                      labelText: 'Enter URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Consumer<UrlProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_urlController.text.isNotEmpty) {
                          provider.shorten(_urlController.text);
                          _urlController.clear();
                        }
                      },
                      child: const Text('Shorten'),
                    );
                  },
                ),
              ],
            ),
          ),
          Consumer<UrlProvider>(
            builder: (context, provider, child) {
               if (provider.errorMessage != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: provider.urls.length,
                  itemBuilder: (context, index) {
                    final url = provider.urls[index];
                    return UrlListItem(
                      url: url,
                      onDelete: () => provider.delete(url.id),
                      onCopy: () {
                        Clipboard.setData(ClipboardData(text: url.shortUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')),
                        );
                      },
                      onShowQr: () {
                        // Show QR code dialog
                         showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SizedBox(
                              width: 200,
                              height: 200,
                              child: Center(
                                child: QrImageView(
                                  data: url.shortUrl,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
