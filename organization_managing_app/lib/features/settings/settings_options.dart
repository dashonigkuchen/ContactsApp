import 'package:flutter/material.dart';

class SettingsOptions {
  // static List<DropdownMenuItem<ThemeMode>>? getThemeModeOptions({
  //   required BuildContext context,
  // }) {
  //   return [
  //     const DropdownMenuItem<ThemeMode>(
  //       value: ThemeMode.system,
  //       child: Text("System"),
  //     ),
  //     const DropdownMenuItem<ThemeMode>(
  //       value: ThemeMode.light,
  //       child: Text("Light"),
  //     ),
  //     const DropdownMenuItem<ThemeMode>(
  //       value: ThemeMode.dark,
  //       child: Text("Dark"),
  //     ),
  //   ];
  // }

  static List<DropdownMenuEntry<ThemeMode>> getThemeModeOptions({
    required BuildContext context,
  }) {
    return [
      const DropdownMenuEntry<ThemeMode>(
        value: ThemeMode.system,
        label: "System",
        leadingIcon: Icon(Icons.phone_android),
      ),
      const DropdownMenuEntry<ThemeMode>(
        value: ThemeMode.light,
        label: "Light",
        leadingIcon: Icon(Icons.light_mode),
      ),
      const DropdownMenuEntry<ThemeMode>(
        value: ThemeMode.dark,
        label: "Dark",
        leadingIcon: Icon(Icons.dark_mode),
      ),
    ];
  }

  static List<DropdownMenuItem<Locale>>? getLanguageOptions() {
    return [
      const DropdownMenuItem<Locale>(
        value: Locale("en"),
        child: Text("English"),
      ),
      const DropdownMenuItem<Locale>(
        value: Locale("de"),
        child: Text("Deutsch"),
      ),
    ];
  }
}
