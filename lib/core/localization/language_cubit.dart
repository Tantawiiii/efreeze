import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../constant/app_texts.dart';
import 'app_language.dart';
import '../services/storage_service.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(this._storageService)
      : super(_resolveInitialLocale(_storageService)) {
    AppTexts.updateLocale(state);
  }

  final StorageService _storageService;

  Future<void> setLanguage(AppLanguage language) async {
    final locale = language.locale;
    if (locale == state) return;
    AppTexts.updateLocale(locale);
    emit(locale);
    await _storageService.saveLanguageCode(language.code);
  }

  AppLanguage get currentLanguage => appLanguageFromLocale(state);

  static Locale _resolveInitialLocale(StorageService storageService) {
    final code = storageService.getLanguageCode();
    final language = appLanguageFromCode(code);
    return language.locale;
  }
}

