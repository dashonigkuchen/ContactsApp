import 'package:flutter/material.dart';
import 'package:organization_managing_app/appwrite/auth/cubit/auth_cubit.dart';
import 'package:organization_managing_app/appwrite/splash/cubit/splash_cubit.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/core/routes/routes.dart';
import 'package:organization_managing_app/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/appwrite/members/cubit/members_cubit.dart';
import 'package:intl/intl_standalone.dart' if (dart.library.html) 'package:intl/intl_browser.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => MembersCubit()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Organization Managing App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
