import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/core/language/language_provider.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/core/theme/app_theme.dart';
import 'package:todo_app/core/theme/theme_provider.dart';
import 'package:todo_app/features/auth/cubit/login_cubit.dart';
import 'package:todo_app/features/auth/cubit/logout_cubit.dart';
import 'package:todo_app/features/auth/cubit/register_cubit.dart';
import 'package:todo_app/features/splash/cubit/splash_cubit.dart';
import 'package:todo_app/features/todo/cubit/todo_cubit.dart';
import 'package:todo_app/core/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  setupLocator();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: ChangeNotifierProvider(
        create: (_) => LanguageProvider(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => RegisterCubit()),
            BlocProvider(create: (_) => LoginCubit()),
            BlocProvider(create: (_) => SplashCubit()),
            BlocProvider(create: (_) => TodoCubit()),
            BlocProvider(create: (_) => LogoutCubit()),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Todo App",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      routerConfig: router,
      supportedLocales: L10n.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      locale: Provider.of<LanguageProvider>(context).locale,
    );
  }
}
