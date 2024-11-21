import 'package:flutter/material.dart';
import 'package:todo_app/core/language/translation.dart';

class SettingsOptions {
  static List<DropdownMenuItem<ThemeMode>>? getThemeModeOptions({
    required BuildContext context,
  }) {
    return [
      DropdownMenuItem<ThemeMode>(
        value: ThemeMode.system,
        child: Text(translator(context).settingThemeSystem),
      ),
      DropdownMenuItem<ThemeMode>(
        value: ThemeMode.light,
        child: Text(translator(context).settingThemeLight),
      ),
      DropdownMenuItem<ThemeMode>(
        value: ThemeMode.dark,
        child: Text(translator(context).settingThemeDark),
      ),
    ];
  }

  static List<DropdownMenuItem<Locale>>? getLanguageOptions() {
    return [
      DropdownMenuItem<Locale>(
        value: Locale("en"),
        child: const Text("English"),
      ),
      DropdownMenuItem<Locale>(
        value: Locale("de"),
        child: const Text("Deutsch"),
      ),
    ];
  }
}
