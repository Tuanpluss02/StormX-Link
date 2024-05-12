import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/home/home_cubit.dart';
import '../../common/enums.dart';
import 'show_confirm_dialog.dart';
import 'show_qrcode.dart';

class ItemWidget extends StatelessWidget {
  final String id;
  final String urlShort;
  final String longUrl;
  final ScreenType screenType;

  const ItemWidget({
    super.key,
    required this.urlShort,
    required this.longUrl,
    required this.id,
    required this.screenType,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(urlShort,
          style: const TextStyle(
              fontFamily: 'Circular',
              color: Colors.black,
              overflow: TextOverflow.ellipsis)),
      subtitle: Text(longUrl,
          style: const TextStyle(
              fontFamily: 'Circular',
              color: Colors.black,
              overflow: TextOverflow.ellipsis)),
      trailing: screenType == ScreenType.web
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.black),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: urlShort));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Copied to clipboard',
                          style: TextStyle(fontFamily: 'Circular'),
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code, color: Colors.black),
                  onPressed: () {
                    showQrcode(context, MediaQuery.of(context).size, urlShort,
                        screenType);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.black),
                  onPressed: () {
                    showConfirmDialog(
                      title: 'Are you sure you want to delete this URL?',
                      onPressed: () {
                        Navigator.pop(context);
                        context.read<HomeCubit>().deleteUrl(id: id);
                      },
                      context: context,
                      size: MediaQuery.of(context).size,
                      screenType: screenType,
                    );
                  },
                ),
              ],
            )
          : PopupMenuButton(itemBuilder: ((context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.copy, color: Colors.black),
                    title: const Text('Copy'),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: urlShort));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.qr_code, color: Colors.black),
                    title: const Text('QR Code'),
                    onTap: () {
                      showQrcode(context, MediaQuery.of(context).size, urlShort,
                          screenType);
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.delete, color: Colors.black),
                    title: const Text('Delete'),
                    onTap: () {
                      showConfirmDialog(
                        title: 'Are you sure you want to delete this URL?',
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<HomeCubit>().deleteUrl(id: id);
                        },
                        context: context,
                        size: MediaQuery.of(context).size,
                        screenType: screenType,
                      );
                    },
                  ),
                ),
              ];
            })),
    );
  }
}
