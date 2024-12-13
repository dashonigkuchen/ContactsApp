import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/appwrite/auth/cubit/auth_cubit.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';
import 'package:organization_managing_app/core/widgets/custom_circular_loader.dart';
import 'package:organization_managing_app/core/widgets/custom_snackbar.dart';
import 'package:organization_managing_app/core/widgets/custom_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool _isPasswordVisible = false;

  void _validateAndRegister() {
    if (_registerFormKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
            firstName: _firstNameTextController.text,
            lastName: _lastNameTextController.text,
            email: _emailTextController.text,
            password: _passwordTextController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
              // TODO
            }
          },
          builder: (context, state) {
            return Form(
              key: _registerFormKey,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _firstNameTextController,
                      validator: (String? input) {
                        if (input!.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obsecureText: false,
                      labelText: "First Name",
                      suffix: null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _lastNameTextController,
                      validator: (String? input) {
                        if (input!.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obsecureText: false,
                      labelText: "Last Name",
                      suffix: null,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
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
                        _validateAndRegister();
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _validateAndRegister,
                      icon: const Icon(Icons.app_registration),
                      label: const Text("Register"),
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
