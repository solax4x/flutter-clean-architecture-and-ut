import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ika/domain/usecases/authentication.dart';
import 'package:ika/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:ika/presentation/blocs/authentication/authentication_event.dart';
import 'package:ika/presentation/blocs/login/login_event.dart';
import 'package:ika/presentation/blocs/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc _authenticationBloc;
  final Authentication _authentication;

  LoginBloc(
      {@required AuthenticationBloc authenticationBloc,
      @required Authentication authentication})
      : assert(authenticationBloc != null),
        assert(authentication != null),
        _authenticationBloc = authenticationBloc,
        _authentication = authentication,
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithId) {
      yield* _mapLoginWithEmailToState(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailToState(
      LoginWithId event) async* {
    yield LoginLoading();
    final result = await _authentication
        .signIn(Params(id: event.email, password: event.password));
    yield* result.fold((failure) async* {
      yield LoginFailure(error: '認証エラー');
    }, (user) async* {
      _authenticationBloc.add(Login(user: user));
      yield LoginSuccess();
      yield LoginInitial();
    });
  }
}
