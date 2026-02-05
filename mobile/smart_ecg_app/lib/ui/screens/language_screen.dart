import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/locale_controller.dart';
import '../../core/localization/i18n.dart';
import '../widgets/language_tile.dart'; // Import the new widget

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final localeCtl = ref.read(localeControllerProvider.notifier);
    final i18n = I18n.of(context, ref);

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.tr('language')),
      ),
      body: ListView(
        children: [
          LanguageTile(
            flag: '🇬🇧',
            label: 'English',
            isSelected: locale.languageCode == 'en',
            onTap: () {
              localeCtl.setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          LanguageTile(
            flag: '🇹🇷',
            label: 'Türkçe',
            isSelected: locale.languageCode == 'tr',
            onTap: () {
              localeCtl.setLocale(const Locale('tr'));
              Navigator.pop(context);
            },
          ),
          LanguageTile(
            flag: '🇩🇪',
            label: 'Deutsch',
            isSelected: locale.languageCode == 'de',
            onTap: () {
              localeCtl.setLocale(const Locale('de'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}