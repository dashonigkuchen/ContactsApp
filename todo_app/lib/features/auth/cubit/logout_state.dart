part of 'logout_cubit.dart';

sealed class LogoutState {}

final class LogoutInitial extends LogoutState {}

final class LogoutLoading extends LogoutState {}

final class LogoutSuccess extends LogoutState {}

final class LogoutError extends LogoutState {
  final Failure failure;

  LogoutError({
    required this.failure,
  });
}
