import 'package:restaurant_manager/application/errors/BaseError.dart';

class GeneralErrorMessages {
  static const String serverError = "Server Error";
  static const String networkError = "Network Error";
}

class ServerError extends BaseError {
  ServerError() : super(GeneralErrorMessages.serverError);
}

class NetworkError extends BaseError {
  NetworkError() : super(GeneralErrorMessages.networkError);
}