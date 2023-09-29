import 'package:restaurant_manager/domain/models/UserModel.dart';
import 'package:restaurant_manager/presentation/shared/constants/login_types.dart';

import '../../../domain/models/TokenModel.dart';
import '../../errors/BaseError.dart';
import 'package:dartz/dartz.dart';

abstract class IAuthService {
  Future<Either<BaseError, TokenModel>> login(String email, String password, LoginTypes loginType);

  Future<Either<BaseError, UserModel>> getCurrentUser();

  Future<Either<BaseError, TokenModel>> refreshToken();

  Future<Either<BaseError, void>> loadCachedAuthData();

  Future<Either<BaseError, void>> logout();
}