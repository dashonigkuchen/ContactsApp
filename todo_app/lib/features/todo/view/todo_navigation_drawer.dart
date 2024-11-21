import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/core/language/translation.dart';
import 'package:todo_app/core/routes/route_name.dart';
import 'package:todo_app/core/utils/app_image_url.dart';
import 'package:todo_app/core/utils/custom_snackbar.dart';
import 'package:todo_app/core/utils/full_screen_dialog_loader.dart';
import 'package:todo_app/features/auth/cubit/logout_cubit.dart';

class TodoNavigationDrawer extends StatelessWidget {
  const TodoNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutLoading) {
            FullScreenDialogLoader.show(context);
          } else if (state is LogoutSuccess) {
            FullScreenDialogLoader.cancel(context);
            context.goNamed(RouteNames.login);
            CustomSnackbar.showSuccess(
              context,
              translator(context).infoSuccess,
            );
          } else if (state is LogoutError) {
            FullScreenDialogLoader.cancel(context);
            CustomSnackbar.showError(
              context,
              Failure.createFailureString(
                context: context,
                failure: state.failure,
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
                    image: AssetImage(AppImageUrl.logo),
                  ),
                ),
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(translator(context).titleSettings),
                onTap: () {
                  Navigator.of(context).pop();
                  context.pushNamed(RouteNames.settings);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text(translator(context).titleLogout),
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    title: translator(context).titleLogout,
                    desc: translator(context).askLogout,
                    btnCancelText: translator(context).buttonCancel,
                    dismissOnTouchOutside: true,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      context.read<LogoutCubit>().logout();
                    },
                  ).show();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
