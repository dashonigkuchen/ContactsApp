import 'package:flutter/material.dart';
import 'package:organization_managing_app/appwrite/cubit/auth_cubit.dart';
import 'package:organization_managing_app/core/locator/locator.dart';
import 'package:organization_managing_app/core/theme/app_theme.dart';
import 'package:organization_managing_app/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appwrite Auth Demo',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: AppTheme.lightTheme,
    );
  }
}
