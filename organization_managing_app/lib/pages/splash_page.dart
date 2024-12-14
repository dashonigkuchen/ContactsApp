import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/features/splash/cubit/splash_cubit.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/core/utils/app_images.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/core/widgets/custom_snackbar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkSession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashLoading) {
              CustomCircularLoader.show(context);
            } else if (state is SplashSuccess) {
              CustomCircularLoader.cancel(context);
              context.goNamed(RouteNames.members);
            } else if (state is SplashError) {
              CustomCircularLoader.cancel(context);
              context.goNamed(RouteNames.login);
              CustomSnackbar.showError(
                context,
                state.failure.createFailureString(
                  context: context,
                ),
              );
            }
          },
          builder: (context, state) {
            return Image.asset(
              AppImages.logo,
              width: 80,
              height: 80,
            );
          },
        ),
      ),
    );
  }
}