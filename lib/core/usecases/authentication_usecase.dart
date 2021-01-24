import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ika/core/error/failure.dart';

abstract class AuthenticationUseCase<Type, Params> {
  Future<Either<Failure, Type>> signIn(Params params);
  Future<Either<Failure, Type>> getCurrentUser();
  Future<void> signOut();
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}