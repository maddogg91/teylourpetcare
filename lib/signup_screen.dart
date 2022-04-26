import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



FirebaseFirestore firestore = FirebaseFirestore.instance;
User loggedinUser;

//code for designing the UI of our text field where the user writes his email id or password

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightGreenAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightGreenAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  
	void initState(){
	super.initState();
	getCurrentUser();
	}
	
	 void getCurrentUser() async {
    try {
      final us = await _auth.currentUser;
      if (us != null) {
        loggedinUser = us;
      }
    } catch (e) {
      print(e);
    }
  }
  
  
  String firstname;
  String lastname;
  String email;
  String password;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
  var client= firestore.collection('client').doc();
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
			Image.network('https://i.ibb.co/ZNSrgv4/logo.jpg',
			height:250,
			width:250,),  
			 TextField(
                 
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    firstname = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your first name')),
              SizedBox(
                height: 24.0,
              ),
			   TextField(
         
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    lastname = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your last name')),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your Password')),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour: Colors.greenAccent,
                title: 'Register',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
						
						
				
					      final m = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
				
					   final log= await _auth.currentUser;
						
						var cont= true;
					
					 while(cont){
						await Future.delayed(const Duration(seconds: 10), (){
						if(!log.uid.isEmpty){
						cont= false;
						}
						
						});
					 }
					
					client.set({
						'firstname': firstname,
						'lastname': lastname,
						'id': client.id,
						'uid': log.uid,
						'about': 'empty',
						'imagePath': 'https://cdn3.vectorstock.com/i/thumb-large/32/12/default-avatar-profile-icon-vector-39013212.jpg',
						'email': email
					});
                    if (newUser != null) {
					  var pet= firestore.collection('pets').doc(client.id);
					  var data = new Map();
					  pet.set({
					  '1': data
					  });
                      Navigator.pushNamed(context, 'home_screen');
                    }
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}