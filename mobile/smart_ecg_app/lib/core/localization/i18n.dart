import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'locale_controller.dart';

final translationsProvider =
    FutureProvider<Map<String, String>>((ref) async {
  final locale = ref.watch(localeControllerProvider);
  final path = 'assets/lang/${locale.languageCode}.json';

  final jsonStr = await rootBundle.loadString(path);
  final Map<String, dynamic> decoded = json.decode(jsonStr);

  return decoded.map((k, v) => MapEntry(k, v.toString()));
});

class I18n {
  final Map<String, String> _strings;

  I18n(this._strings);

  String tr(String key) => _strings[key] ?? key;

  static I18n of(BuildContext context, WidgetRef ref) {
    final translations = ref.watch(translationsProvider);

    return translations.when(
      data: (map) => I18n(map),
      loading: () => I18n(const {}),
      error: (error, stackTrace) => I18n(const {}),
    );
  }
}
