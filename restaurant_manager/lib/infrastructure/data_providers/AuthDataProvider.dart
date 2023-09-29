import 'package:dio/dio.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/exceptions.dart';
import 'package:restaurant_manager/infrastructure/data_providers/shared/interceptors.dart';
import '../../domain/models/TokenModel.dart';
import '../../domain/models/UserModel.dart';
import '../auth/AuthInfo.dart';
import 'shared/end_points.dart';

abstract class IAuthDataProvider {
  Future<TokenModel> loginAdmin(String email, String password);
  Future<TokenModel> loginStudent(String email, String password);
  Future<TokenModel> refreshAdminToken(String refreshToken);
  Future<TokenModel> refreshStudentToken(String refreshToken);
  Future<UserModel> getCurrentAdmin();
  Future<UserModel> getCurrentStudent();
}

class AuthDataProvider implements IAuthDataProvider {
  late final Dio _dio;

  AuthDataProvider() {
    _dio = Dio(BaseOptions(
        baseUrl: EndPoints.serverUrl,
        connectTimeout: 2000,
        receiveTimeout: 10000,
        sendTimeout: 10000,
        validateStatus: (status) {
          return status != null && status < 500;
        }));

    _dio.interceptors.add(InterceptorsWrapper(onRequest: onRequestInterceptor));
  }

  @override
  Future<TokenModel> loginAdmin(String email, String password) async {
    try {
      Response response = await _dio.post(
        "/admins/login",
        options: Options(
            contentType: "application/x-www-form-urlencoded"
        ),
        data: FormData.fromMap(
          {
            "username": email,
            "password": password,
          },
        ),
      );

      if (response.statusCode == 400) {
        throw WrongEmailOrPasswordException();
      }

      return TokenModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<TokenModel> loginStudent(String email, String password) async {
    try {
      Response response = await _dio.post(
        "/students/login",
        options: Options(
            contentType: "application/x-www-form-urlencoded"
        ),
        data: FormData.fromMap(
          {
            "username": email,
            "password": password,
          },
        ),
      );

      if (response.statusCode == 400) {
        throw WrongEmailOrPasswordException();
      }

      return TokenModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<TokenModel> refreshAdminToken(String refreshToken) async {
    try {
      final response = await _dio.post("/admins/refresh",
          options: Options(headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.refreshToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidRefreshTokenException();
      }

      return TokenModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<TokenModel> refreshStudentToken(String refreshToken) async {
    try {
      final response = await _dio.post("/students/refresh",
          options: Options(headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.refreshToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidRefreshTokenException();
      }

      return TokenModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentAdmin() async {
    try {
      final response = await _dio.get("/admins/me",
          options: Options(headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      return UserModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentStudent() async {
    try {
      final response = await _dio.get("/students/me",
          options: Options(headers: {
            "Authorization": "Bearer ${AuthInfo.tokenModel!.accessToken}",
          }));

      if (response.statusCode == 401) {
        throw InvalidAccessTokenException();
      }

      return UserModel.fromJson(response.data);
    } on DioError {
      throw ServerException();
    }
  }
}