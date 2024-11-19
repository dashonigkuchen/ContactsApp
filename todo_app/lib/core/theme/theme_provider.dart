import 'package:flutter/material.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/core/utils/app_string.dart';
import 'package:todo_app/core/utils/secure_storage_service.dart';
import 'package:todo_app/core/utils/storage_key.dart';

class ThemeProvider with ChangeNotifier {
  static const List<String> possibleThemes = [
    AppString.lightThemeMode,
    AppString.darkThemeMode,
    AppString.systemThemeMode,
  ];

  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _setInitialThemeMode();
  }

  void _setInitialThemeMode() async {
    String? themeMode = await _secureStorageService.getValue(
      StorageKey.themeMode,
    );

    if (themeMode != null) {
      setThemeMode(
        themeMode: themeMode,
      );
    }
  }

  void _setThemeMode({
    required ThemeMode themeMode,
  }) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void setThemeMode({
    required String themeMode,
  }) {
    if (themeMode == AppString.lightThemeMode) {
      _setThemeMode(
        themeMode: ThemeMode.light,
      );
    } else if (themeMode == AppString.darkThemeMode) {
      _setThemeMode(
        themeMode: ThemeMode.dark,
      );
    } else if (themeMode == AppString.systemThemeMode) {
      _setThemeMode(
        themeMode: ThemeMode.system,
      );
    } else {
      throw FormatException();
    }

    _secureStorageService.setValue(
      StorageKey.themeMode,
      themeMode,
    );
  }
}
