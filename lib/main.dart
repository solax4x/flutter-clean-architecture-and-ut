import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ika/injection_container.dart';
import 'package:ika/presentation/blocs/authentication/authentication_bloc.dart';
import 'package:ika/presentation/blocs/authentication/authentication_state.dart';
import 'package:ika/presentation/pages/login_page.dart';
import 'package:ika/presentation/pages/top_page.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (_) => gi<AuthenticationBloc>(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Concierge',
        theme: ThemeData(
            primarySwatch: Colors.blue, primaryColor: Color(0xffFF8F00)),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return TopPage.create(state.user);
          } else {
            return LoginPage();
          }
        }));
  }
}
