import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:ika/core/error/failure.dart';
import 'package:ika/core/usecases/authentication_usecase.dart';
import 'package:ika/domain/entities/user.dart';
import 'package:ika/domain/repositories/authentication_repository.dart';



class Authentication implements AuthenticationUseCase<User, Params> {
  final AuthenticationRepository _repository;

  Authentication(this._repository);

  @override
  Future<Either<Failure, User>> signIn(Params params) async {
    return await _repository.authentication(params.id, params.password);
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return await _repository.getCurrentUser();
  }

  @override
  Future<void> signOut() async {
    return await _repository.signOut();
  }
}

class Params extends Equatable {
  final String id;
  final String password;

  Params({@required this.id, @required this.password});

  @override
  List<Object> get props => [id, password];
}
