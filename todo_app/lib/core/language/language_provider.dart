import 'package:flutter/material.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/core/utils/secure_storage_service.dart';
import 'package:todo_app/core/utils/storage_key.dart';

class LanguageProvider with ChangeNotifier {
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  Locale _locale = Locale("de");

  Locale get locale => _locale;

  LanguageProvider() {
    getLanguage();
  }

  Locale getLanguage() {
    _secureStorageService.getValue(StorageKey.languageCode).then((value) {
      if (value == null) {
        setLanguage(locale: _locale);
      } else {
        setLanguage(locale: Locale(value));
      }
    });
    return _locale;
  }

  void setLanguage({
    required Locale locale,
  }) {
    _locale = locale;

    _secureStorageService.setValue(
      StorageKey.languageCode,
      locale.languageCode,
    );

    notifyListeners();
  }
}
