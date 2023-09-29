// create all auth errors
import 'BaseError.dart';

class AuthErrorMessages {
  static const String wrongEmailOrPassword = 'Wrong email or password';
  static const String invalidAccessTokenError = "Invalid access token";
  static const String invalidRefreshTokenError = "Invalid refresh token";
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

