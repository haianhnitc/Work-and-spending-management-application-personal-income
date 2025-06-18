import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class L10n {
  static final all = [
    const Locale('en', ''),
    const Locale('vi', ''),
  ];

  static List<LocalizationsDelegate> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return 'us';
      case 'vi':
        return 'vn';
      default:
        return 'vi';
    }
  }
}
