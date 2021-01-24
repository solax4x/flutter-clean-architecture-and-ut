import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ika/injection_container.dart';
import 'package:ika/presentation/blocs/login/login_bloc.dart';
import 'package:ika/presentation/blocs/login/login_event.dart';
import 'package:ika/presentation/blocs/login/login_state.dart';
import 'package:ika/presentation/utils/text_form_field_util.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => gi<LoginBloc>(),
      child: _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() async {
      if (_key.currentState.validate()) {
        BlocProvider.of<LoginBloc>(context).add(LoginWithId(
            email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginFailure) {
                _showError(context, state.error);
              }
            },
            child: Container(
                constraints: BoxConstraints.expand(),
                child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                  if (state is LoginLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Stack(children: [
                    Container(
                        constraints: BoxConstraints.expand(),
                        child: Image(
                          image: AssetImage("images/bg_login.png"),
                          fit: BoxFit.fitHeight,
                        )),
                    Container(
                        constraints: BoxConstraints.expand(),
                        child: Image(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          image: AssetImage("images/mask_bg_login.png"),
                          fit: BoxFit.fill,
                        )),
                    Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Form(
                                key: _key,
                                autovalidateMode: _autoValidate
                                    ? AutovalidateMode.onUserInteraction
                                    : AutovalidateMode.disabled,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Concierge',
                                        style: TextStyle(
                                            fontSize: 36,
                                            fontFamily: 'JosefinSans',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 100),
                                    TextFormFieldUtil.getLoginFormTextField(
                                        controller: _emailController,
                                        prefixIcon: Icon(Icons.email_outlined,
                                            size: TextFormFieldUtil.ICON_SIZE,
                                            color:
                                                TextFormFieldUtil.ICON_COLOR),
                                        labelText: "メールアドレス",
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "必須です";
                                          }
                                        }),
                                    SizedBox(height: 24),
                                    TextFormFieldUtil.getLoginFormTextField(
                                        controller: _passwordController,
                                        prefixIcon: Icon(
                                            Icons.lock_open_outlined,
                                            size: TextFormFieldUtil.ICON_SIZE,
                                            color:
                                                TextFormFieldUtil.ICON_COLOR),
                                        labelText: "パスワード",
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return "必須です";
                                          }
                                        }),
                                    SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: FlatButton(
                                          child: Text("パスワードを忘れた場合",
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    ),
                                    SizedBox(height: 70),
                                    CupertinoButton(
                                      borderRadius: BorderRadius.circular(36.0),
                                      onPressed: state is LoginLoading
                                          ? () {}
                                          : _onLoginButtonPressed,
                                      child: Text('ログイン'),
                                      color: Theme.of(context).primaryColor,
                                    )
                                  ],
                                )))),
                    Positioned(
                        bottom: MediaQuery.of(context).padding.bottom,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                                alignment: Alignment.center,
                                child: FlatButton(
                                    child: Text('アカウントを作成する',
                                        style: TextStyle(
                                            color: Colors.white,
                                            decoration:
                                                TextDecoration.underline)),
                                    onPressed: () {}))))
                  ]);
                }))));
  }

  void _showError(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black87,
    ));
  }
}
