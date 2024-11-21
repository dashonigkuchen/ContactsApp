import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/core/language/translation.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/core/routes/route_name.dart';
import 'package:todo_app/core/theme/app_color.dart';
import 'package:todo_app/core/utils/app_image_url.dart';
import 'package:todo_app/core/utils/custom_snackbar.dart';
import 'package:todo_app/core/utils/full_screen_dialog_loader.dart';
import 'package:todo_app/core/utils/secure_storage_service.dart';
import 'package:todo_app/core/utils/storage_key.dart';
import 'package:todo_app/core/utils/validation_rules.dart';
import 'package:todo_app/core/widgets/custom_text_form_field.dart';
import 'package:todo_app/core/widgets/rounded_elevated_button.dart';
import 'package:todo_app/features/auth/cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  final SecureStorageService _secureStorageService =
      locator<SecureStorageService>();
  bool saveCredentials = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearText() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginLoading) {
                  FullScreenDialogLoader.show(context);
                } else if (state is LoginSuccess) {
                  clearText();
                  FullScreenDialogLoader.cancel(context);
                  CustomSnackbar.showSuccess(
                      context, translator(context).infoSuccess);
                  _secureStorageService.setValue(
                      StorageKey.userId, state.session.userId);
                  _secureStorageService.setValue(
                      StorageKey.sessionId, state.session.$id);
                  context.goNamed(RouteNames.todo);
                } else if (state is LoginError) {
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
                return Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      Image.asset(
                        AppImageUrl.logo,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextFormField(
                        controller: _emailController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return translator(context).errorFieldRequired;
                          } else if (!ValidationRules.emailValidation
                              .hasMatch(val)) {
                            return translator(context).errorEmailWrong;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        obsecureText: false,
                        hintText: translator(context).hintEmail,
                        suffix: null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return translator(context).errorFieldRequired;
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obsecureText: !isPasswordVisible,
                        hintText: translator(context).hintPassword,
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColor.greyColor,
                          ),
                        ),
                        onFieldSubmitted: (text) {
                          if (_loginFormKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(
                                email: _emailController.text,
                                password: _passwordController.text);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            translator(context).checkboxSaveCredentials,
                          ),
                          Checkbox(
                            value: saveCredentials,
                            onChanged: (val) {
                              setState(() {
                                saveCredentials = val!;
                              });
                            },
                          ),
                        ],
                      ),
                      RoundedElevatedButton(
                        buttonText: translator(context).buttonLogin,
                        onPressed: () {
                          if (_loginFormKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(
                                email: _emailController.text,
                                password: _passwordController.text);
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          clearText();
                          context.pushNamed(RouteNames.register);
                        },
                        child: Text(translator(context).buttonCreateAccount),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
