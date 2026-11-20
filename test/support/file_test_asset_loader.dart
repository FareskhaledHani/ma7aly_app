import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

// Load the real language files outside the widget-test fake-async asset channel.
// This keeps locale-switch tests independent without substituting translations.
class FileTestAssetLoader extends AssetLoader {
  FileTestAssetLoader()
    : _translations = {
        for (final language in ['ar', 'en'])
          language: jsonDecode(
            File('assets/languages/$language.json').readAsStringSync(),
          ) as Map<String, dynamic>,
      };
  final Map<String, Map<String, dynamic>> _translations;
  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) =>
      Future.value(_translations[locale.languageCode]);
}
