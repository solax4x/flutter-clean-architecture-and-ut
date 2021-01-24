import 'package:dartz/dartz.dart';
import 'package:ika/domain/entities/user.dart';
import 'package:ika/core/error/failure.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, User>> authentication(String email, String password);
  Future<Either<Failure, User>> getCurrentUser();
  Future<void> signOut();
}