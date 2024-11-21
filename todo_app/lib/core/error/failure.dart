import 'package:flutter/material.dart';
import 'package:todo_app/core/language/translation.dart';

enum FailureType {
  appwrite,
  internal,
  internet,
}

class Failure {
  final String message;
  final FailureType type;

  Failure({
    required this.message,
    required this.type,
  });

  static String createFailureString({
    required BuildContext context,
    required Failure failure,
  }) {
    switch (failure.type) {
      case FailureType.appwrite:
        return failure.message;
      case FailureType.internal:
        return failure.message;
      case FailureType.internet:
        return translator(context).errorInternetError;
    }
  }
}
