import 'package:bloc/bloc.dart';
import 'package:restaurant_manager/presentation/authentication/bloc/authentication_states.dart';
import 'package:restaurant_manager/presentation/shared/constants/login_types.dart';

import '../../../application/services/auth/IAuthService.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthService authService;
  AuthCubit({required this.authService}) : super(AuthInitialState());

  void login(String email, String password, LoginTypes loginType) async {
    emit(AuthLoginLoadingState());
    final response = await authService.login(email, password, loginType);
    response.fold(
      (error) => emit(AuthLoginErrorState(error.message)),
      (tokenModel) => emit(AuthLoginSuccessState()),
    );
  }

  void getCurrentUser() {
    emit(AuthGetUserLoadingState());
    authService.getCurrentUser().then((response) {
      response.fold(
        (error) => emit(AuthGetUserErrorState(error.message)),
        (userModel) => emit(AuthGetUserSuccessState()),
      );
    });
    emit(AuthGetUserSuccessState());
  }

  void logout() {
    emit(AuthLogoutLoadingState());
    authService.logout().then((response) {
      response.fold(
        (error) => emit(AuthLogoutErrorState(error.message)),
        (userModel) => emit(AuthLogoutSuccessState()),
      );
    });
    emit(AuthLogoutSuccessState());
  }
}