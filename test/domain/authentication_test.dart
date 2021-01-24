import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ika/core/error/failure.dart';
import 'package:ika/data/models/user.dart';
import 'package:ika/domain/repositories/authentication_repository.dart';
import 'package:ika/domain/usecases/authentication.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  Authentication usecase;
  MockAuthenticationRepository mockAuthenticationRepository;

  setUp(() {
    mockAuthenticationRepository = MockAuthenticationRepository();
    usecase = Authentication(mockAuthenticationRepository);
  });

  group('signIn', () {
    final email = 'test@gmail.com';
    final tUserModel = UserModel(address: email);
    test('認証成功時RightにUserModelが返却される', () async {
      when(mockAuthenticationRepository.authentication(email, any))
          .thenAnswer((_) async => Right(tUserModel));
      final result = await usecase.signIn(Params(id: email, password: 'test'));
      expect(result, Right(tUserModel));
      verify(mockAuthenticationRepository.authentication(email, 'test'));
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });

    test('パスワードに誤りがあり、認証失敗時LeftにServerFailureが返却される', () async {
      when(mockAuthenticationRepository.authentication(email, any))
          .thenAnswer((_) async => Left(ServerFailure()));
      final result = await usecase.signIn(Params(id: email, password: 'bad_test'));
      expect(result, Left(ServerFailure()));
      verify(mockAuthenticationRepository.authentication(email, 'bad_test'));
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });

  group('getCurrentUser', (){
    final email = 'test@gmail.com';
    final tUserModel = UserModel(address: email);
    test('現在のユーザ情報が設定されていて取得出来る',() async {
      when(mockAuthenticationRepository.getCurrentUser())
          .thenAnswer((_) async => Right(tUserModel));
      final result = await usecase.getCurrentUser();
      expect(result, Right(tUserModel));
      verify(mockAuthenticationRepository.getCurrentUser());
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });

    test('現在のユーザ情報が設定されていなくてCacheFailureが返却される',() async {
      when(mockAuthenticationRepository.getCurrentUser())
          .thenAnswer((_) async => Left(CacheFailure()));
      final result = await usecase.getCurrentUser();
      expect(result, Left(CacheFailure()));
      verify(mockAuthenticationRepository.getCurrentUser());
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });

  group('signOut', (){
    test('サインアウト処理呼び出し時にリポジトリのサインアウトのみが実行される',() async {
      await usecase.signOut();
      verify(mockAuthenticationRepository.signOut());
      verifyNoMoreInteractions(mockAuthenticationRepository);
    });
  });

}
