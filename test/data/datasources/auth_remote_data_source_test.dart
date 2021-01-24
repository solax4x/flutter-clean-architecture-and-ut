import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core_plugin_interface/amplify_core_plugin_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ika/core/error/exceptions.dart';
import 'package:ika/data/datasources/auth_remote_data_source.dart';
import 'package:ika/data/models/user.dart';
import 'package:matcher/src/type_matcher.dart';
import 'package:mockito/mockito.dart';

class MockAuthCategory extends Mock implements AuthCategory {}

class MockCognitoSignInResult extends Mock implements CognitoSignInResult {}

class MockAWSCognitoUserPoolTokens extends Mock
    implements AWSCognitoUserPoolTokens {}

void main() {
  AuthRemoteDataSourceImpl dataSource;
  MockAuthCategory mockAuthCategory;

  setUp(() {
    mockAuthCategory = MockAuthCategory();
    dataSource = AuthRemoteDataSourceImpl(authCategory: mockAuthCategory);
  });

  group('authentication', () {
    final email = 'test@gmail.com';
    final password = 'password';
    final tUser = UserModel(address: email);
    test('認証成功', () async {
      MockCognitoSignInResult mockCognitoSignInResult =
          MockCognitoSignInResult();
      when(mockAuthCategory.signIn(username: email, password: password))
          .thenAnswer((_) async => mockCognitoSignInResult);
      when(mockCognitoSignInResult.isSignedIn).thenReturn(true);
      final result = await dataSource.authentication(email, password);
      expect(result, tUser);
    });

    test('認証失敗', () async {
      MockCognitoSignInResult mockCognitoSignInResult =
          MockCognitoSignInResult();
      when(mockAuthCategory.signIn(username: email, password: password))
          .thenAnswer((_) async => mockCognitoSignInResult);
      when(mockCognitoSignInResult.isSignedIn).thenReturn(false);
      expect(() => dataSource.authentication(email, password),
          throwsA(TypeMatcher<ServerException>()));
    });
  });
}
