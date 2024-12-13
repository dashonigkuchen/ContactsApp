import 'package:appwrite/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:organization_managing_app/appwrite/auth/cubit/auth_cubit.dart';
import 'package:organization_managing_app/core/routes/route_names.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';
import 'package:organization_managing_app/core/utils/app_images.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/core/widgets/custom_snackbar.dart';
import 'package:organization_managing_app/core/widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isPasswordVisible = false;

  void _validateAndSignIn() {
    if (_loginFormKey.currentState!.validate()) {
      context.read<AuthCubit>().signInWithEmail(
            email: _emailTextController.text,
            password: _passwordTextController.text,
          );
    }
  }

  void _reset() {
    _loginFormKey.currentState!.reset();
    _emailTextController.clear();
    _passwordTextController.clear();
    _isPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Organization Managing App"),
      ),
      body: Center(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              CustomCircularLoader.show(context);
            } else if (state is AuthError) {
              CustomCircularLoader.cancel(context);
              CustomSnackbar.showError(context, state.failure.message);
            } else if (state is AuthSuccess) {
              CustomCircularLoader.cancel(context);
              context.goNamed(RouteNames.members);
            }
          },
          builder: (context, state) {
            return Form(
              key: _loginFormKey,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      controller: _emailTextController,
                      validator: (String? input) {
                        if (input!.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      obsecureText: false,
                      labelText: "Email",
                      suffix: null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _passwordTextController,
                      validator: (String? input) {
                        if (input!.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obsecureText: !_isPasswordVisible,
                      labelText: "Password",
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: AppColor.greyColor,
                        ),
                      ),
                      onFieldSubmitted: (val) {
                        _validateAndSignIn();
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _validateAndSignIn,
                      icon: const Icon(Icons.login),
                      label: const Text("Sign in"),
                    ),
                    TextButton(
                      onPressed: () {
                        _reset();
                        context.pushNamed(RouteNames.register);
                      },
                      child: const Text('Create Account'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _reset();
                            context.read<AuthCubit>().signInWithProvider(
                                provider: OAuthProvider.google);
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white),
                          child: SvgPicture.asset(
                            AppImages.googleIcon,
                            width: 12,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _reset();
                            context.read<AuthCubit>().signInWithProvider(
                                provider: OAuthProvider.apple);
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white),
                          child: SvgPicture.asset(
                            AppImages.appleIcon,
                            width: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
