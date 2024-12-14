import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organization_managing_app/data/provider/repository/auth_repository.dart';
import 'package:organization_managing_app/core/error/failure.dart';
import 'package:organization_managing_app/core/locator/locator.dart';

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
}