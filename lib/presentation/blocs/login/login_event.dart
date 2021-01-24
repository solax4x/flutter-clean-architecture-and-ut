import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginWithId extends LoginEvent {
  final String email;
  final String password;

  LoginWithId({@required this.email, @required this.password});

  @override
  List<Object> get props => [email, password];
}