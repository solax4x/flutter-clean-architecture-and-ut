import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core_plugin_interface/amplify_core_plugin_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:ika/core/error/exceptions.dart';
import 'package:ika/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheCurrentUser(UserModel userToCache);

  Future<UserModel> getCurrentUser();

  Future<String> getCachedToken();

  Future<void> signOut();
}

const CACHED_USER_ID = 'CACHED_USER_ID';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AuthCategory _authCategory;
  final SharedPreferences _sharedPreferences;

  AuthLocalDataSourceImpl(
      {@required SharedPreferences sharedPreferences,
      @required AuthCategory authCategory})
      : assert(sharedPreferences != null),
        assert(authCategory != null),
        _sharedPreferences = sharedPreferences,
        _authCategory = authCategory;

  @override
  Future<String> getCachedToken() => _getToken();

  @override
  Future<String> _getToken() async {
    final CognitoAuthSession session = await _authCategory.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );
    if (session.isSignedIn) {
      return session.userPoolTokens.accessToken;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCurrentUser(UserModel userToCache) {
    return _sharedPreferences.setString(
      CACHED_USER_ID,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<void> signOut() {
    _authCategory.signOut();
    return _sharedPreferences.clear();
  }

  Future<UserModel> getCurrentUser() async {
    final jsonStr = _sharedPreferences.getString(CACHED_USER_ID);
    if (jsonStr != null) {
      return UserModel.fromJson(json.decode(jsonStr));
    } else {
      throw CacheException();
    }
  }
}
