import 'package:flutter/material.dart';
import 'package:organization_managing_app/core/theme/theme_provider.dart';
import 'package:organization_managing_app/features/auth/cubit/auth_cubit.dart';
import 'package:organization_managing_app/features/paid_membership_fee/cubit/paid_membership_fee_cubit.dart';
import 'package:organization_managing_app/features/splash/cubit/splash_cubit.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/core/routes/routes.dart';
import 'package:organization_managing_app/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/features/members/cubit/members_cubit.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await findSystemLocale();
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SplashCubit()),
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => MembersCubit()),
          BlocProvider(create: (_) => PaidMembershipFeeCubit()),
        ],
        child: const MainApp(),
      ),
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
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      routerConfig: router,
    );
  }
}
