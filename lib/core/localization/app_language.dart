import 'package:flutter/material.dart';

enum AppLanguage { ar, en }

extension AppLanguageX on AppLanguage {
  String get code => this == AppLanguage.ar ? 'ar' : 'en';

  Locale get locale => Locale(code);
}

AppLanguage appLanguageFromCode(String? code) {
  if (code == null) return AppLanguage.ar;
  return code.toLowerCase() == 'en' ? AppLanguage.en : AppLanguage.ar;
}

AppLanguage appLanguageFromLocale(Locale locale) {
  return appLanguageFromCode(locale.languageCode);
}

