import 'package:flutter/material.dart';
import 'authentication.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Container(
          child: Center(
        child: FlatButton(
          child: Text('Sign in with Google'),
          onPressed: Authentication.handleLogin,
        ),
      )),
    );
  }
}