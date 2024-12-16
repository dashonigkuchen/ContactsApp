import 'package:flutter/material.dart';

class SettingsOptions {
  static List<DropdownMenuItem<ThemeMode>>? getThemeModeOptions({
    required BuildContext context,
  }) {
    return [
      const DropdownMenuItem<ThemeMode>(
        value: ThemeMode.system,
        child: Text("System"),
      ),
      const DropdownMenuItem<ThemeMode>(
        value: ThemeMode.light,
        child: Text("Light"),
      ),
      const DropdownMenuItem<ThemeMode>(
        value: ThemeMode.dark,
        child: Text("Dark"),
      ),
    ];
  }

  static List<DropdownMenuItem<Locale>>? getLanguageOptions() {
    return [
      const DropdownMenuItem<Locale>(
        value: Locale("en"),
        child: const Text("English"),
      ),
      const DropdownMenuItem<Locale>(
        value: Locale("de"),
        child: const Text("Deutsch"),
      ),
    ];
  }
}