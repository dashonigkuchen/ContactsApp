import 'package:flutter/material.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'core/routes/routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_string.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppString.appName,
      theme: AppTheme.darkThemeMode,
      routerConfig: router,
    );
  }
}
