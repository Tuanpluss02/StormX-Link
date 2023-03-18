import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final Function() onCopy;
  final Function() onQrGen;
  final Function() onEdit;
  final Function() onDelete;

  const ItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.onCopy,
    required this.onQrGen,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: onCopy,
          ),
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: onQrGen,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
