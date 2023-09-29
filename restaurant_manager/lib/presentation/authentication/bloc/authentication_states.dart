class AuthState {}

class AuthInitialState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState(this.message);
}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {}

class AuthLoginLoadingState extends AuthLoadingState {}

class AuthLoginSuccessState extends AuthSuccessState {}

class AuthLoginErrorState extends AuthErrorState {
  AuthLoginErrorState(String message) : super(message);
}

class AuthGetUserLoadingState extends AuthLoadingState {}

class AuthGetUserSuccessState extends AuthSuccessState {}

class AuthGetUserErrorState extends AuthErrorState {
  AuthGetUserErrorState(String message) : super(message);
}

class AuthLogoutLoadingState extends AuthLoadingState {}

class AuthLogoutSuccessState extends AuthSuccessState {}

class AuthLogoutErrorState extends AuthErrorState {
  AuthLogoutErrorState(String message) : super(message);
}
