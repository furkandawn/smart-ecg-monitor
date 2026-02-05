import 'package:flutter/material.dart';

/// Shows a platform-adaptive dialog and returns TRUE if confirmed, FALSE if cancelled.
class ConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String content,
    String cancelText = "Cancel",
    String confirmText = "Yes",
    bool isDestructive = false, // If true, the 'Yes' button will be red
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(
          content,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(cancelText),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? Colors.red : Colors.blue,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false; // Treat dismissing (clicking outside) as 'false'
  }
}