import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'login_screen.dart';
import 'glogin_screen.dart';
import 'home.dart';
import 'package:splashscreen/splashscreen.dart';
import 'conversationScreen.dart';
import 'homeBuilder.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
	   title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Splash(),
      debugShowCheckedModeBanner: false,
      routes: {
		'welcome_Screen': (context) => WelcomeScreen(),
		'signup_screen': (context) => RegistrationScreen(),
		'login_screen': (context) => LoginScreen(),
		'glogin_screen': (context) => SignInScreen(),
		'home_screen': (context) => HomeScreen()
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
	
	return SplashScreen(
      seconds: 5,
	  navigateAfterSeconds: new WelcomeScreen(),
      title: new Text('Maddogg Software Development Company',textScaleFactor: 1,),
      image: new Image.network('https://i.ibb.co/yFLx4c8/splashscreen.gif'),
      loadingText: Text("Stand By"),
      photoSize: 200.0,
      loaderColor: Colors.blue,
	  
    );
  }
}