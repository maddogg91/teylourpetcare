import 'package:flutter/material.dart';
import 'rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[50],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
			  Image.network('https://i.ibb.co/ZNSrgv4/logo.jpg',
			height:250,
			width:250,),  
                RoundedButton(
                  colour: Colors.lightGreenAccent,
                  title: 'Log In',
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                ),
                RoundedButton(
                    colour: Colors.greenAccent,
                    title: 'Register',
                    onPressed: () {
                      Navigator.pushNamed(context, 'signup_screen');
                    }),
              ]),
        ));
  }
  }