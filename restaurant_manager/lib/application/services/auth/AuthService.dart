import 'package:dartz/dartz.dart';
import 'package:restaurant_manager/application/errors/AuthErrors.dart';
import 'package:restaurant_manager/application/errors/BaseError.dart';
import 'package:restaurant_manager/application/errors/GeneralErrors.dart';
import 'package:restaurant_manager/application/services/auth/IAuthService.dart';
import 'package:restaurant_manager/domain/models/TokenModel.dart';
import 'package:restaurant_manager/domain/models/UserModel.dart';
import 'package:restaurant_manager/infrastructure/auth/AuthInfo.dart';
import 'package:restaurant_manager/infrastructure/data_providers/AuthDataProvider.dart';
import 'package:restaurant_manager/infrastructure/local_storage/CacheStorage.dart';
import 'package:restaurant_manager/presentation/shared/constants/login_types.dart';

import '../../../infrastructure/data_providers/shared/exceptions.dart';
import '../../../infrastructure/network_status/network_status.dart';

class AuthService implements IAuthService {
  final IAuthDataProvider authDataProvider;
  final ICacheStorage cacheStorage;
  final INetworkStatus networkStatus;

  AuthService(
      {required this.authDataProvider,
      required this.cacheStorage,
      required this.networkStatus});

  @override
  Future<Either<BaseError, UserModel>> getCurrentUser() async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }
    if (AuthInfo.tokenModel == null) {
      return Left(InvalidAccessTokenError());
    }

    try {
      UserModel userModel = AuthInfo.loginType == LoginTypes.student
          ? await authDataProvider.getCurrentStudent()
          : await authDataProvider.getCurrentAdmin();

      AuthInfo.setUser(userModel);
      await cacheStorage.storeUserInCache(userModel);
      return Right(userModel);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    }
  }

  @override
  Future<Either<BaseError, void>> loadCachedAuthData() async {
    AuthInfo.setLoginType(await cacheStorage.getCachedLoginType());
    AuthInfo.setUser(await cacheStorage.getCachedUser());
    AuthInfo.setTokenModel(await cacheStorage.getCachedTokens());

    return const Right(null);
  }

  @override
  Future<Either<BaseError, TokenModel>> login(
      String email, String password, LoginTypes loginType) async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }

    try {
      TokenModel tokenModel = loginType == LoginTypes.student
          ? await authDataProvider.loginStudent(email, password)
          : await authDataProvider.loginAdmin(email, password);
      AuthInfo.setLoginType(loginType);
      cacheStorage.storeLoginTypeInCache(loginType.name);
      cacheStorage.storeTokensInCache(tokenModel);
      AuthInfo.setTokenModel(tokenModel);
      return Right(tokenModel);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    } on InvalidAccessTokenException {
      return Left(InvalidAccessTokenError());
    } on WrongEmailOrPasswordException {
      return Left(WrongEmailOrPasswordError());
    }
  }

  @override
  Future<Either<BaseError, TokenModel>> refreshToken() async {
    if (!await networkStatus.isConnected()) {
      return Left(NetworkError());
    }

    TokenModel? tokens = AuthInfo.tokenModel;
    if (tokens == null) {
      return Left(InvalidRefreshTokenError());
    }

    try {
      TokenModel tokenModel = AuthInfo.loginType == LoginTypes.student
          ? await authDataProvider.refreshStudentToken(tokens.refreshToken)
          : await authDataProvider.refreshAdminToken(tokens.refreshToken);
      cacheStorage.storeTokensInCache(tokenModel);
      AuthInfo.setTokenModel(tokenModel);
      return Right(tokenModel);
    } on ServerException {
      return Left(ServerError());
    } on InvalidRefreshTokenException {
      return Left(InvalidRefreshTokenError());
    }
  }

  @override
  Future<Either<BaseError, void>> logout() async {
    cacheStorage.clearCache();
    AuthInfo.setTokenModel(null);
    AuthInfo.setUser(null);
    AuthInfo.setLoginType(null);
    return const Right(null);
  }
}
