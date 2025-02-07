import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/core/utils/app_images.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/core/widgets/custom_snackbar.dart';
import 'package:organization_managing_app/features/auth/cubit/auth_cubit.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  void _redirectToPage(BuildContext context, String selectedRoute) {
    final currentPath =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    Navigator.of(context).pop();
    if (currentPath.substring(1) != selectedRoute) {
      context.goNamed(selectedRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            CustomCircularLoader.show(context);
          } else if (state is AuthSuccess) {
            CustomCircularLoader.cancel(context);
            context.goNamed(RouteNames.login);
            CustomSnackbar.showSuccess(
              context,
              "Success",
            );
          } else if (state is AuthError) {
            CustomCircularLoader.cancel(context);
            CustomSnackbar.showError(
              context,
              state.failure.createFailureString(
                context: context,
              ),
            );
          }
        },
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppImages.logo),
                  ),
                ),
                child: const Text(
                  "Menu",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.pages),
                title: const Text("Members"),
                onTap: () => _redirectToPage(context, RouteNames.members),
              ),
              ListTile(
                leading: const Icon(Icons.money),
                title: const Text("Paid Membership Fees"),
                onTap: () => _redirectToPage(context, RouteNames.paidMembershipFee),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () => _redirectToPage(context, RouteNames.settings),
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text("Logout"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Are you sure to logout?"),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.read<AuthCubit>().signOut();
                            },
                            child: const Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
