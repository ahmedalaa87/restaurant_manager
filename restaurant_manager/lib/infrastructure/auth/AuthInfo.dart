import 'package:restaurant_manager/domain/models/TokenModel.dart';
import 'package:restaurant_manager/domain/models/UserModel.dart';

class AuthProvider {
  static UserModel? user;
  static TokenModel? tokenModel;

  static setUser(UserModel? user) {
    AuthProvider.user = user;
  }

  static setTokenModel(TokenModel? tokenModel) {
    AuthProvider.tokenModel = tokenModel;
  }
}