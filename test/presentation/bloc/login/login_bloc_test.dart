import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ika/core/error/failure.dart';
import 'package:ika/data/models/user.dart';
import 'package:ika/domain/usecases/authentication.dart';
import 'package:ika/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:ika/presentation/blocs/authentication/authentication_event.dart';
import 'package:ika/presentation/blocs/login/login_bloc.dart';
import 'package:ika/presentation/blocs/login/login_event.dart';
import 'package:ika/presentation/blocs/login/login_state.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

class MockAuthentication extends Mock implements Authentication {}

void main() {
  LoginBloc bloc;
  MockAuthenticationBloc mockAuthenticationBloc;
  MockAuthentication mockAuthentication;

  setUp(() {
    mockAuthentication = MockAuthentication();
    mockAuthenticationBloc = MockAuthenticationBloc();
    bloc = LoginBloc(
        authenticationBloc: mockAuthenticationBloc,
        authentication: mockAuthentication);
  });

  group('LoginWithId', () {
    final tUserModel = UserModel(address: 'test@gmail.com');
    test(
        'idとパスワードでログインしてAuthenticationBlocにLoginイベントを追加。ログインstateは初期化LoginInitialされる。',
        () async {
      Params signInParams = Params(id: 'test', password: 'test');
      when(mockAuthentication.signIn(signInParams))
          .thenAnswer((_) async => Right(tUserModel));
      final expected = [LoginLoading(), LoginSuccess(), LoginInitial()];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoginWithId(email: 'test', password: 'test'));
      await untilCalled(mockAuthenticationBloc.add(any));
      verify(mockAuthenticationBloc.add(Login(user: tUserModel)));
    });

    test('ログイン失敗。ログインstateはLoginFailureとなる。', () async {
      Params signInParams = Params(id: 'test', password: 'test');
      when(mockAuthentication.signIn(signInParams))
          .thenAnswer((_) async => Left(ServerFailure()));
      final expected = [LoginLoading(), LoginFailure(error: '認証エラー')];

      expectLater(bloc, emitsInOrder(expected));
      bloc.add(LoginWithId(email: 'test', password: 'test'));
    });
  });
}
