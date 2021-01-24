import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ika/domain/entities/user.dart';
import 'package:ika/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:ika/presentation/blocs/authentication/authentication_event.dart';

class TopPage extends StatelessWidget {
  final User user;

  TopPage._(this.user);

  static create(User user) => TopPage._(user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          child: Text('ログアウト'),
          onPressed: () =>
              BlocProvider.of<AuthenticationBloc>(context).add(Logout()),
        ),
      ),
    );
  }
}
