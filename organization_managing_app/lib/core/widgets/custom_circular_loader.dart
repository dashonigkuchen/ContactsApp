import 'package:flutter/material.dart';
import 'package:organization_managing_app/core/theme/app_color.dart';

class CustomCircularLoader {
  static bool _isDialogOpen = false;

  static void show(
    BuildContext context,
  ) {
    if (!_isDialogOpen) {
      _isDialogOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: AppColor.transparentColor,
            builder: (BuildContext context) {
              return const PopScope(
                canPop: false,
                child: Center(
                  child: CircularProgressIndicator()
                ),
              );
            },
          ).then((_) {
            _isDialogOpen = false;
          });
        }
      });
    }
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
