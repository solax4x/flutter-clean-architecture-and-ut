import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ika/core/error/exceptions.dart';
import 'package:ika/core/error/failure.dart';
import 'package:ika/core/network/network_info.dart';
import 'package:ika/data/datasources/auth_local_data_source.dart';
import 'package:ika/data/datasources/auth_remote_data_source.dart';
import 'package:ika/data/models/user.dart';
import 'package:ika/data/repositories/authentication_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  AuthenticationRepositoryImpl repository;
  MockNetworkInfo mockNetworkInfo;
  MockAuthRemoteDataSource mockAuthRemoteDataSource;
  MockAuthLocalDataSource mockAuthLocalDataSource;

  setUp(() {
    mockAuthRemoteDataSource = MockAuthRemoteDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthenticationRepositoryImpl(
      remoteDataSource: mockAuthRemoteDataSource,
      localDataSource: mockAuthLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('オンライン時のテスト', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('オフライン時のテスト', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('authentication', () {
    final tUserModel = UserModel(address: 'test@gmail.com');
    test('オンライン確認がされているか', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.authentication('test', 'test');
      verify(mockNetworkInfo.isConnected);
    });
    runTestsOnline(() {
      test('認証成功時に結果としてUserModelを取得出来る', () async {
        when(mockAuthRemoteDataSource.authentication(any, any))
            .thenAnswer((_) async => tUserModel);
        final result = await repository.authentication('test', 'test');
        verify(mockAuthRemoteDataSource.authentication('test', 'test'));
        expect(result, equals(Right(tUserModel)));
      });

      test('認証成功時にUserModelをローカルキャッシュに保存出来る', () async {
        when(mockAuthRemoteDataSource.authentication(any, any))
            .thenAnswer((_) async => tUserModel);
        await repository.authentication('test', 'test');
        verify(mockAuthRemoteDataSource.authentication('test', 'test'));
        verify(mockAuthLocalDataSource.cacheCurrentUser(tUserModel));
      });

      test('認証失敗時にServerFailureを受け取る', () async {
        when(mockAuthRemoteDataSource.authentication(any, any))
            .thenThrow(ServerException());
        final result = await repository.authentication('test', 'test');
        verify(mockAuthRemoteDataSource.authentication('test', 'test'));
        verifyZeroInteractions(mockAuthLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });
  });
}
