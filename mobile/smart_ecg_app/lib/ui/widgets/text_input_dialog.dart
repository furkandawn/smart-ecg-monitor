import 'package:flutter/material.dart';

/// Shows a dialog with a TextField and returns the typed String (or null if cancelled).
class TextInputDialog {
  static Future<String?> show(
    BuildContext context, {
    required String title,
    String? initialValue,
    String confirmText = "Done",
    String cancelText = "Cancel",
    int maxLines = 1,
  }) async {
    final controller = TextEditingController(text: initialValue);

    return showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(cancelText),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}