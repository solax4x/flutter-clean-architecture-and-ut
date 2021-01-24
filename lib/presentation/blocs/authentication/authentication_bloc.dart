import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ika/domain/usecases/authentication.dart';
import 'package:ika/presentation/blocs/authentication/authentication_event.dart';
import 'package:ika/presentation/blocs/authentication/authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Authentication _authentication;

  AuthenticationBloc({@required Authentication authentication})
      : assert(authentication != null),
        _authentication = authentication,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AppLoaded) {
      yield* _mapAppLoadedToState(event);
    }

    if (event is Login) {
      yield* _mapUserLoggedInToState(event);
    }

    if (event is Logout) {
      yield* _mapUserLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async* {
    yield AuthenticationLoading();
    final currentUser = await _authentication.getCurrentUser();

    yield currentUser.fold((failure) => AuthenticationNotAuthenticated(),
        (user) => AuthenticationAuthenticated(user: user));
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(Login event) async* {
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(Logout event) async* {
    await _authentication.signOut();
    yield AuthenticationNotAuthenticated();
  }
}
