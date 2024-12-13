import 'package:flutter/material.dart';

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

  String createFailureString({
    required BuildContext context,
  }) {
    switch (type) {
      case FailureType.appwrite:
        return message;
      case FailureType.internal:
        return message;
      case FailureType.internet:
        return "No internet found";
    }
  }
}