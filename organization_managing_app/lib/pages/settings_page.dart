import 'package:flutter/material.dart';
import 'package:organization_managing_app/core/theme/theme_provider.dart';
import 'package:organization_managing_app/features/settings/settings_options.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Theme"),
                  DropdownButton<ThemeMode>(
                    value: Provider.of<ThemeProvider>(context).themeMode,
                    icon: const Icon(
                      Icons.arrow_downward,
                    ),
                    elevation: 16,
                    items: SettingsOptions.getThemeModeOptions(
                      context: context,
                    ),
                    onChanged: (ThemeMode? themeMode) {
                      if (themeMode != null) {
                        Provider.of<ThemeProvider>(
                          context,
                          listen: false,
                        ).setThemeMode(
                          themeMode: themeMode,
                        );
                      }
                    },
                  ),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     const Text("Language"),
              //     DropdownButton<Locale>(
              //       value: Provider.of<LanguageProvider>(context).locale,
              //       icon: const Icon(
              //         Icons.arrow_downward,
              //       ),
              //       elevation: 16,
              //       items: SettingsOptions.getLanguageOptions(),
              //       onChanged: (Locale? locale) {
              //         if (locale != null) {
              //           Provider.of<LanguageProvider>(
              //             context,
              //             listen: false,
              //           ).setLanguage(
              //             locale: locale,
              //           );
              //         }
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
