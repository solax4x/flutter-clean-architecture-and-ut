import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:ika/core/error/exceptions.dart';
import 'package:ika/core/error/failure.dart';
import 'package:ika/core/network/network_info.dart';
import 'package:ika/data/datasources/auth_local_data_source.dart';
import 'package:ika/data/datasources/auth_remote_data_source.dart';
import 'package:ika/domain/entities/user.dart';
import 'package:ika/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthenticationRepositoryImpl(
      {@required remoteDataSource,
      @required localDataSource,
      @required networkInfo})
      : assert(remoteDataSource != null),
        assert(localDataSource != null),
        assert(networkInfo != null),
        _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  Future<Either<Failure, User>> authentication(
      String email, String password) async {
    return await _auth(email, password);
  }

  Future<Either<Failure, User>> _auth(String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.authentication(email, password);
        _localDataSource.cacheCurrentUser(user);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        print(e);
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getCurrentUser();
      return Right(user);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<void> signOut() async {
    return await _localDataSource.signOut();
  }
}
