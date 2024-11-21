import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/data/provider/repository/auth_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository _authRepository = locator<AuthRepository>();

  SplashCubit() : super(SplashInitial());

  void checkSession() async {
    emit(SplashLoading());

    final res = await _authRepository.checkSession();

    res.fold((failure) => emit(SplashError(failure: failure)),
        (session) => emit(SplashSuccess()));
  }

  void logout() async {
    emit(SplashLoading());

    final res = await _authRepository.logout();

    if (res != null) {
      emit(SplashError(failure: res));
    } else {
      emit(SplashSuccess());
    }
  }
}
