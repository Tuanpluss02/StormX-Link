import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'show_delete_dialog.dart';
import 'show_qrcode.dart';

class ItemWidget extends StatelessWidget {
  final String id;
  final String urlShort;
  final String longUrl;

  const ItemWidget({
    super.key,
    required this.urlShort,
    required this.longUrl,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(urlShort),
      subtitle: Text(longUrl),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: urlShort));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to clipboard'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              showQrcode(context, MediaQuery.of(context).size, urlShort);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDeleteDialog(context, MediaQuery.of(context).size, id);
            },
          ),
        ],
      ),
    );
  }
}
