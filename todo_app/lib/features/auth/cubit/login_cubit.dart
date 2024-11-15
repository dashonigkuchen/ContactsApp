import 'package:appwrite/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/data/provider/repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository = locator<AuthRepository>();

  LoginCubit() : super(LoginInitial());

  void login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    final res = await _authRepository.login(email: email, password: password);

    res.fold((failure) => emit(LoginError(error: failure.message)),
        (session) => emit(LoginSuccess(session: session)));
  }
}
