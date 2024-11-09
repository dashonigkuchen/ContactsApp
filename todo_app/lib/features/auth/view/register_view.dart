import 'package:flutter/material.dart';
import 'package:todo_app/core/theme/app_color.dart';
import 'package:todo_app/core/utils/app_image_url.dart';
import 'package:todo_app/core/utils/app_string.dart';
import 'package:todo_app/core/utils/validation_rules.dart';
import 'package:todo_app/core/widgets/custom_text_form_field.dart';
import 'package:todo_app/core/widgets/rounded_elevated_button.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
            child: Form(
              key: _registerFormKey,
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
                    controller: _firstNameController, 
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppString.required;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name, 
                    obsecureText: false, 
                    hintText: AppString.firstName, 
                    suffix: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _lastNameController, 
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppString.required;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name, 
                    obsecureText: false, 
                    hintText: AppString.lastName, 
                    suffix: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _emailController, 
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppString.required;
                      } else if (!ValidationRules.emailValidation
                          .hasMatch(val)) {
                            return AppString.provideValidEmail;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress, 
                    obsecureText: false, 
                    hintText: AppString.email, 
                    suffix: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _passwordController, 
                    validator: (val) {
                      if (val!.isEmpty) {
                        return AppString.required;
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword, 
                    obsecureText: !isPasswordVisible, 
                    hintText: AppString.email, 
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RoundedElevatedButton(
                    buttonText: AppString.register,
                    onPressed: () {
                      if (_registerFormKey.currentState!.validate()) {}
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}