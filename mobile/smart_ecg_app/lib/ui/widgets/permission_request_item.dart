import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final PermissionStatus? status;
  final VoidCallback onFix;
  final String allowLabel;

  const PermissionRequestItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.onFix,
    required this.allowLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isGranted = status?.isGranted == true;
    final Color iconColor = isGranted ? Colors.green : Colors.red;
    final IconData icon = isGranted ? Icons.check_circle : Icons.error;

    return Card(
      color: Colors.white.withValues(alpha: 0.05),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: Icon(icon, color: iconColor, size: 32),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          isThreeLine: true,
          trailing: isGranted
              ? null
              : TextButton(
                  onPressed: onFix,
                  child: Text(
                    allowLabel,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}