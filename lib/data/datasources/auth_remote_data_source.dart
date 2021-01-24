import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core_plugin_interface/amplify_core_plugin_interface.dart';
import 'package:flutter/material.dart';
import 'package:ika/core/error/exceptions.dart';
import 'package:ika/data/models/user.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> authentication(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthCategory _authCategory;

  AuthRemoteDataSourceImpl({@required AuthCategory authCategory})
      : assert(authCategory != null),
        _authCategory = authCategory;

  @override
  Future<UserModel> authentication(String email, String password) =>
      _auth(email, password);

  Future<UserModel> _auth(String email, String password) async {
    try {
      CognitoSignInResult res =
          await _authCategory.signIn(username: email, password: password);
      if (res.isSignedIn) {
        return UserModel.fromJson({"address": email});
      }
    } on AuthError catch (error) {
      print(error.cause);
    }
    throw ServerException();
  }
}
