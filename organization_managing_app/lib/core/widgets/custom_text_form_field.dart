import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obsecureText,
    this.labelText,
    this.suffix,
    this.onFieldSubmitted,
    this.textInputAction,
    this.formatter,
    this.readOnly,
  });

  final TextEditingController controller;
  final String? Function(String? val)? validator;
  final TextInputType? keyboardType;
  final bool? obsecureText;
  final String? labelText;
  final Widget? suffix;
  final Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final TextInputFormatter? formatter;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obsecureText ?? false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      style: Theme.of(context).textTheme.titleMedium!,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffix: suffix,
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.borderColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.borderColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.appColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.errorColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColor.errorColor, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: AppColor.errorColor, fontSize: 12),
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      inputFormatters: formatter != null ? [formatter!] : null,
      readOnly: readOnly ?? false,
      enabled: readOnly != null ? !readOnly! : true,
    );
  }
}
