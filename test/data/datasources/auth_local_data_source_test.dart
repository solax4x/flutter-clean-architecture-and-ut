import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core_plugin_interface/amplify_core_plugin_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ika/core/error/exceptions.dart';
import 'package:ika/data/datasources/auth_local_data_source.dart';
import 'package:ika/data/models/user.dart';
import 'package:matcher/src/type_matcher.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockAuthCategory extends Mock implements AuthCategory {}

class MockCognitoAuthSession extends Mock implements CognitoAuthSession {}

class MockAWSCognitoUserPoolTokens extends Mock
    implements AWSCognitoUserPoolTokens {}

void main() {
  AuthLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;
  MockAuthCategory mockAuthCategory;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockAuthCategory = MockAuthCategory();
    dataSource = AuthLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences,
        authCategory: mockAuthCategory);
  });

  group('getCachedToken', () {
    test('キャッシュがなくCacheFailureになる', () async {
      MockCognitoAuthSession session = MockCognitoAuthSession();
      when(mockAuthCategory.fetchAuthSession(options: anyNamed('options')))
          .thenAnswer((_) async => session);
      when(session.isSignedIn).thenReturn(false);
      expect(() => dataSource.getCachedToken(),
          throwsA(TypeMatcher<CacheException>()));
    });

    test('トークンが取得出来る', () async {
      const token = 'access_token';
      MockCognitoAuthSession session = MockCognitoAuthSession();
      MockAWSCognitoUserPoolTokens tokens = MockAWSCognitoUserPoolTokens();
      when(mockAuthCategory.fetchAuthSession(options: anyNamed('options')))
          .thenAnswer((_) async => session);
      when(session.isSignedIn).thenReturn(true);
      when(session.userPoolTokens).thenReturn(tokens);
      when(tokens.accessToken).thenReturn(token);
      final result = await dataSource.getCachedToken();
      expect(result, token);
    });
  });

  group('cacheCurrentUser', () {
    final tUser = UserModel(address: 'test@gmail.com');
    test('Userをキャッシュする', () async {
      dataSource.cacheCurrentUser(tUser);
      verify(mockSharedPreferences.setString(
          CACHED_USER_ID, json.encode(tUser.toJson())));
    });
  });

  group('getCurrentUser', () {
    final user = UserModel(address: 'test@gmail.com');
    test('キャッシュされたユーザを取得する', () async {
      when(mockSharedPreferences.getString(CACHED_USER_ID))
          .thenReturn(json.encode(user.toJson()));
      final result = await dataSource.getCurrentUser();
      expect(result, equals(user));
    });

    test('キャッシュされたユーザが無く、CacheExceptionを返す', () async {
      when(mockSharedPreferences.getString(CACHED_USER_ID)).thenReturn(null);
      expect(() => dataSource.getCurrentUser(),
          throwsA(TypeMatcher<CacheException>()));
    });
  });

  group('signOut', () {
    test('サインアウトした時にSharedPreferencesのclearが呼ばれているか', () async {
      when(mockSharedPreferences.clear()).thenAnswer((_) async => true);
      dataSource.signOut();
      verify(mockAuthCategory.signOut());
      verify(mockSharedPreferences.clear());
    });
  });
}
