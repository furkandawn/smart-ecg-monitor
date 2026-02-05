import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/localization/i18n.dart';
import '../screens/language_screen.dart';

class LanguageSelectorTile extends ConsumerWidget {
  const LanguageSelectorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final i18n = I18n.of(context, ref);

    return ListTile(
      title: Text(i18n.tr('language')),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LanguageScreen(),
          ),
        );
      },
    );
  }
}