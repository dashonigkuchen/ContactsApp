import 'package:appwrite/enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/appwrite/auth/auth_repository.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/locator/locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository = locator<AuthRepository>();

  AuthCubit() : super(AuthInitial());

  void register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final res = await _authRepository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    res.fold(
      (failure) => emit(AuthError(failure: failure)),
      (session) => emit(AuthSuccess()),
    );
  }

  void signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final res = await _authRepository.signInWithEmail(
      email: email,
      password: password,
    );

    res.fold(
      (failure) => emit(AuthError(failure: failure)),
      (session) => emit(AuthSuccess()),
    );
  }

  void signInWithProvider({
    required OAuthProvider provider,
  }) async {
    emit(AuthLoading());

    final res = await _authRepository.signInWithProvider(
      provider: provider,
    );

    res.fold(
      (failure) => emit(AuthError(failure: failure)),
      (session) => emit(AuthSuccess()),
    );
  }

  void signOut() async {
    emit(AuthLoading());

    final res = await _authRepository.signOut();

    res != null
        ? (failure) => emit(AuthError(failure: failure))
        : (session) => emit(AuthSuccess());
  }
}
