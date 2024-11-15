part of 'login_cubit.dart';

sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final Session session;

  LoginSuccess({
    required this.session,
  });
}

final class LoginError extends LoginState {
  final String error;

  LoginError({
    required this.error,
  });
}
