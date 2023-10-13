// create all auth errors
import 'BaseError.dart';

class AuthErrorMessages {
  static const String wrongEmailOrPassword = 'Wrong email or password';
  static const String invalidAccessTokenError = "Invalid access token";
  static const String invalidRefreshTokenError = "Invalid refresh token";
  static const String wrongPasswordError = "The provided password is incorrect";
}

class WrongEmailOrPasswordError extends BaseError {
  WrongEmailOrPasswordError() : super(AuthErrorMessages.wrongEmailOrPassword);
}

class InvalidAccessTokenError extends BaseError {
  InvalidAccessTokenError() : super(AuthErrorMessages.invalidAccessTokenError);
}

class InvalidRefreshTokenError extends BaseError {
  InvalidRefreshTokenError() : super(AuthErrorMessages.invalidRefreshTokenError);
}


class WrongPasswordError extends BaseError {
  WrongPasswordError() : super(AuthErrorMessages.wrongPasswordError);
}


