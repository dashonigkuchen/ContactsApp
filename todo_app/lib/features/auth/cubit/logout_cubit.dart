import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/locators/locator.dart';
import 'package:todo_app/data/provider/repository/auth_repository.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final AuthRepository _authRepository = locator<AuthRepository>();
  
  LogoutCubit() : super(LogoutInitial());

  void logout() async {
    emit(LogoutLoading());
    final res = await _authRepository.logout();

    if (res == null) {
      emit(LogoutSuccess());
    } else {
      emit(LogoutError(error: res.message));
    }
  }
}
