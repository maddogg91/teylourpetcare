import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'conversationProvider.dart';
import 'login_screen.dart';


class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
  print("home");
    final User firebaseUser = Provider.of<User>(context);
	print(firebaseUser.toString);
    return (firebaseUser != null)
        ? ConversationProvider(user: firebaseUser)
        : Navigator.pushNamed(context, 'login_screen');
  }
}