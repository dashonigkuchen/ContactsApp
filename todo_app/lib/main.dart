import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/features/auth/cubit/login_cubit.dart';
import 'package:todo_app/features/auth/cubit/register_cubit.dart';
import 'package:todo_app/features/splash/cubit/splash_cubit.dart';
import 'package:todo_app/features/todo/cubit/todo_cubit.dart';
import 'core/routes/routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_string.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  setupLocator();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => RegisterCubit()),
      BlocProvider(create: (_) => LoginCubit()),
      BlocProvider(create: (_) => SplashCubit()),
      BlocProvider(create: (_) => TodoCubit()),
    ],
    child: const MyApp(),
  ));
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
