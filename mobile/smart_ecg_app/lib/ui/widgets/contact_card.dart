import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';

class ContactCard extends ConsumerWidget {
  final String name;
  final String phone;
  final bool isPrimary;
  final ValueChanged<bool> onPrimaryChanged;
  final VoidCallback onDelete;

  const ContactCard({
    super.key,
    required this.name,
    required this.phone,
    required this.isPrimary,
    required this.onPrimaryChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(name),
        subtitle: Text(phone),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary Call Label & Icon
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.phone_in_talk,
                  size: 18,
                  color: Colors.green,
                ),
                const SizedBox(height: 2),
                Text(
                  i18n.tr('primary_call'),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(width: 8),

            // Toggle Switch
            Switch(
              value: isPrimary,
              onChanged: onPrimaryChanged,
            ),
            const SizedBox(width: 8),

            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}