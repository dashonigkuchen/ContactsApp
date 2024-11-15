import 'package:todo_app/core/utils/app_string.dart';

class Failure {
  final String message;

  Failure([
    this.message = AppString.internalServerError,
  ]);
}