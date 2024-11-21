import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/language/language_provider.dart';
import 'package:todo_app/core/language/translation.dart';
import 'package:todo_app/core/theme/theme_provider.dart';
import 'package:todo_app/features/settings/settings_options.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(translator(context).titleSettings),
          ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    translator(context).settingTitleTheme,
                  ),
                  Spacer(),
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
              Row(
                children: [
                  Text(
                    translator(context).settingTitleLanguage,
                  ),
                  Spacer(),
                  DropdownButton<Locale>(
                    value: Provider.of<LanguageProvider>(context).locale,
                    icon: const Icon(
                      Icons.arrow_downward,
                    ),
                    elevation: 16,
                    items: SettingsOptions.getLanguageOptions(),
                    onChanged: (Locale? locale) {
                      if (locale != null) {
                        Provider.of<LanguageProvider>(
                          context,
                          listen: false,
                        ).setLanguage(
                          locale: locale,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
