import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ika/core/error/failure.dart';
import 'package:ika/data/models/user.dart';
import 'package:ika/domain/usecases/authentication.dart';
import 'package:ika/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:ika/presentation/blocs/authentication/authentication_event.dart';
import 'package:ika/presentation/blocs/authentication/authentication_state.dart';
import 'package:mockito/mockito.dart';

class MockAuthentication extends Mock implements Authentication {}

void main() {
  AuthenticationBloc bloc;
  MockAuthentication mockAuthentication;

  setUp(() {
    mockAuthentication = MockAuthentication();
    bloc = AuthenticationBloc(authentication: mockAuthentication);
  });

  group('AppLoaded', () {
    final tUserModel = UserModel(address: 'test@gmail.com');
    test(
        'ローディング時にgetCurrentUserを呼び出しUserModelを取得しstateをAuthenticationAuthenticatedにする',
        () async {
      when(mockAuthentication.getCurrentUser())
          .thenAnswer((_) async => Right(tUserModel));
      final expected = [
        AuthenticationLoading(),
        AuthenticationAuthenticated(user: tUserModel),
      ];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(AppLoaded());
    });

    test(
        'ローディング時にgetCurrentUserを呼び出しローカルデータが無くCacheFailureを取得しstateをAuthenticationNotAuthenticatedにする',
        () {
      when(mockAuthentication.getCurrentUser())
          .thenAnswer((_) async => Left(CacheFailure()));
      final expected = [
        AuthenticationLoading(),
        AuthenticationNotAuthenticated(),
      ];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(AppLoaded());
    });
  });

  group('Login', () {
    final tUserModel = UserModel(address: 'test@gmail.com');
    test('ログインイベントを実行し、stateをAuthenticationAuthenticatedにする', () {
      final expected = [AuthenticationAuthenticated(user: tUserModel)];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(Login(user: tUserModel));
    });
  });

  group('Login', () {
    test(
        'ログアウトイベントを実行し、usecaseのsignOutを呼び出しstateをAuthenticationNotAuthenticatedにする',
        () {
      final expected = [AuthenticationNotAuthenticated()];
      expectLater(bloc, emitsInOrder(expected));
      bloc.add(Logout());
    });
  });
}
