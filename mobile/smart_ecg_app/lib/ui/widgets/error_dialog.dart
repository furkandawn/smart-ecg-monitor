import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/i18n.dart';

class ErrorDialog {
  static void showErrorDialog(BuildContext context, WidgetRef ref, String message) {
    final i18n = I18n.of(context, ref);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Icon(Icons.error_outline, color: Colors.red, size: 40),
        content: Text(
          message, 
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(i18n.tr('ok')),
          ),
        ],
      ),
    );
  }
}