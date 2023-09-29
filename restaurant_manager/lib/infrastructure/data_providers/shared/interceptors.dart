import 'package:dio/dio.dart';
import 'package:restaurant_manager/application/errors/AuthErrors.dart';
import 'package:restaurant_manager/application/errors/GeneralErrors.dart';
import 'package:restaurant_manager/application/services/auth/IAuthService.dart';
import '../../../dependency_container.dart';
import 'checks.dart';
import 'exceptions.dart';

void onRequestInterceptor(
    RequestOptions options, RequestInterceptorHandler handler) async {
  String? accessToken = options.headers["Authorization"];
  if (accessToken == null) {
    return handler.next(options);
  }

  if (checkTokenIntegrity(accessToken)) {
    return handler.next(options);
  }

  if (options.path == "/refresh") {
    throw InvalidRefreshTokenException();
  }

  final tokensOrFailure =
  await getIt<IAuthService>().refreshToken();

  return tokensOrFailure.fold((failure) {
    if (failure is ServerError) {
      return handler.reject(DioError(requestOptions: options));
    }

    if (failure is InvalidRefreshTokenError) {
      throw InvalidRefreshTokenException();
    }
  }, (tokensEntity) {
    options.headers["Authorization"] = "Bearer ${tokensEntity.accessToken}";
    return handler.next(options);
  });
}
