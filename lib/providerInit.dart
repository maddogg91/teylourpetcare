import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'login_screen.dart';
import 'conversationProvider.dart';
import 'homeBuilder.dart';
import 'conversationScreen.dart';

class ProviderInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: FirebaseAuth.instance.authStateChanges(), child: MaterialApp(
      title: 'Chat Application',
	  home: Home(),
	  debugShowCheckedModeBanner: false,
     routes: {
		'home': (context) => Home(),
		'homeBuilder': (context) => HomeBuilder(),
        'login_screen': (context) => LoginScreen(),
		'conversationProvider': (context) => ConversationProvider(),
		'conversationScreen': (context) => ConversationScreen()
      },
    ));
  }
}