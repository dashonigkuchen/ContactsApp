import 'package:flutter/material.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/core/storage/secure_storage_service.dart';
import 'package:organization_managing_app/core/storage/storage_key.dart';

class ThemeProvider with ChangeNotifier {
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    getThemeMode();
  }

  ThemeMode getThemeMode() {
    _secureStorageService
        .getValue(
      StorageKey.themeMode,
    )
        .then((value) {
      if (value == null) {
        setThemeMode(
          themeMode: _themeMode,
        );
      } else {
        setThemeMode(
          themeMode: ThemeMode.values.byName(value),
        );
      }
    });
    return _themeMode;
  }

  void setThemeMode({
    required ThemeMode themeMode,
  }) {
    _themeMode = themeMode;

    _secureStorageService.setValue(
      StorageKey.themeMode,
      themeMode.name,
    );

    notifyListeners();
  }
}
