import 'package:flutter/material.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';

class CustomCircularLoader {
  static bool _isDialogOpen = false;

  static void show(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: AppColor.transparentColor,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            CircularProgressIndicator(),
          ]),
        );
      },
    );
    _isDialogOpen = true;
  }

  static void cancel(
    BuildContext context,
  ) {
    if (_isDialogOpen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogOpen = false;
    }
  }
}
