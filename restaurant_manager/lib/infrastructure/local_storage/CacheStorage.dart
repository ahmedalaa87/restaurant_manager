import 'dart:convert';

import 'package:restaurant_manager/infrastructure/local_storage/constants.dart';
import 'package:restaurant_manager/presentation/shared/constants/login_types.dart';

import '../../domain/models/TokenModel.dart';
import '../../domain/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ICacheStorage {
  Future<String?> get(String key);

  Future<void> set(String key, String value);

  Future<void> remove(String key);

  Future<TokenModel?> getCachedTokens();

  Future<UserModel?> getCachedUser();

  Future<LoginTypes?> getCachedLoginType();

  Future<void> storeTokensInCache(TokenModel tokensModel);

  Future<void> storeUserInCache(UserModel userModel);

  Future<void> storeLoginTypeInCache(String loginType);

  Future<void> clearCache();
}

class CacheStorage implements ICacheStorage {
  final SharedPreferences sharedPreferences;

  CacheStorage(this.sharedPreferences);

  @override
  Future<String?> get(String key) {
    return Future.value(sharedPreferences.getString(key));
  }

  @override
  Future<TokenModel?> getCachedTokens() {
    String? tokensData = sharedPreferences.getString(CacheKeys.token);

    if (tokensData != null) {
      return Future.value(TokenModel.fromJson(jsonDecode(tokensData)));
    }
    return Future.value(null);
  }

  @override
  Future<UserModel?> getCachedUser() {
    String? userData = sharedPreferences.getString(CacheKeys.user);

    if (userData != null) {
      return Future.value(UserModel.fromJson(jsonDecode(userData)));
    }
    return Future.value(null);
  }

  @override
  Future<void> remove(String key) async {
    sharedPreferences.remove(key);
  }

  @override
  Future<void> set(String key, String value) {
    return sharedPreferences.setString(key, value);
  }

  @override
  Future<void> storeTokensInCache(TokenModel tokensModel) {
    return sharedPreferences.setString(CacheKeys.token, jsonEncode(tokensModel.toJson()));
  }

  @override
  Future<void> storeUserInCache(UserModel userModel) {
    return sharedPreferences.setString(CacheKeys.user, jsonEncode(userModel.toJson()));
  }

  @override
  Future<LoginTypes?> getCachedLoginType() {
    String? loginType = sharedPreferences.getString(CacheKeys.loginType);

    if (loginType != null) {
      return Future.value(LoginTypes.values.firstWhere((element) => element.name == loginType));
    }
    return Future.value(null);
  }

  @override
  Future<void> storeLoginTypeInCache(String loginType) {
    return sharedPreferences.setString(CacheKeys.loginType, loginType);
  }

  @override
  Future<void> clearCache() {
    return sharedPreferences.clear();
  }
}