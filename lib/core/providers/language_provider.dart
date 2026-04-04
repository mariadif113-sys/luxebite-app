import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('ar', '')); // Default to Arabic as requested earlier

  void setLocale(Locale lr) {
    state = lr;
  }

  void toggleLanguage() {
    if (state.languageCode == 'ar') {
      state = const Locale('en', '');
    } else if (state.languageCode == 'en') {
      state = const Locale('fr', '');
    } else {
      state = const Locale('ar', '');
    }
  }

  String get currentLanguageName {
    switch (state.languageCode) {
      case 'ar': return 'العربية';
      case 'fr': return 'Français';
      case 'en': 
      default: return 'English';
    }
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});
