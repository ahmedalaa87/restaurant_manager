import 'package:restaurant_manager/domain/models/TokenModel.dart';
import 'package:restaurant_manager/domain/models/UserModel.dart';

import '../../core/constants/login_types.dart';

class AuthInfo {
  static UserModel? user;
  static TokenModel? tokenModel;
  static LoginTypes? loginType;

  static void setUser(UserModel? user) {
    AuthInfo.user = user;
  }

  static void setTokenModel(TokenModel? tokenModel) {
    AuthInfo.tokenModel = tokenModel;
  }

  static void setLoginType(LoginTypes? loginType) {
    AuthInfo.loginType = loginType;
  }

}