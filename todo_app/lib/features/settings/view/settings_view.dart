import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/core/theme/theme_provider.dart';
import 'package:todo_app/core/utils/app_string.dart';
import 'package:todo_app/core/utils/secure_storage_service.dart';
import 'package:todo_app/core/utils/storage_key.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormState>();
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  static String _themeMode = "System";

  @override
  void initState() {
    super.initState();

    _setDefaults();
  }

  Future<void> _setDefaults() async {
    final theme =
        await _secureStorageService.getValue(StorageKey.themeMode) ?? "System";

    setState(() {
      _themeMode = theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    AppString.theme,
                  ),
                  DropdownButton<String>(
                    value: _themeMode,
                    icon: const Icon(
                      Icons.arrow_downward,
                    ),
                    elevation: 16,
                    items: ThemeProvider.possibleThemes
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      _secureStorageService.setValue(
                          StorageKey.themeMode, value!);
                      setState(() {
                        _themeMode = value;
                      });
                      Provider.of<ThemeProvider>(
                        context,
                        listen: false,
                      ).setThemeMode(
                        themeMode: _themeMode,
                      );
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
