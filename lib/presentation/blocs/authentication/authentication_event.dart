import 'package:equatable/equatable.dart';
import 'package:ika/domain/entities/user.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppLoaded extends AuthenticationEvent {}

class Login extends AuthenticationEvent {
  final User user;
  Login({@required this.user});

  @override
  List<Object> get props => [user];
}

class Logout extends AuthenticationEvent {}