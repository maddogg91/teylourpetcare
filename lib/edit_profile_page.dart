import 'dart:io';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'appbar_widget.dart';
import 'button_widget.dart';
import 'profile_widget.dart';
import 'textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

User loggedinUser;

FirebaseFirestore fs = FirebaseFirestore.instance;
LocalUser user;
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  
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

  @override
  Widget build(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(

final us= _auth.currentUser;
		final String id= us.uid;
		stream: fs.collection('client').snapshots(),
		builder: (context, snapshot){
			if(!snapshot.hasData){
				
			return Scaffold();
			}
			
			else if(snapshot.hasData){
			List<DocumentSnapshot> documents= snapshot.data.docs;
			for(DocumentSnapshot doc in documents){
				
				if(id== doc.get("uid")){
				 user= LocalUser(doc.get("firstname")+" " + doc.get("lastname")
				, doc.get("id"), doc.get("imagePath"), doc.get("email"), doc.get("about"), doc.get("isDarkMode")) ;
				}
				
			}

   return ThemeSwitchingArea(
        child: Builder(
          builder: (context) => Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: user.imagePath,
                  isEdit: true,
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Full Name',
                  text: user.name,
                  onChanged: (name) {},
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'Email',
                  text: user.email,
                  onChanged: (email) {},
                ),
                const SizedBox(height: 24),
                TextFieldWidget(
                  label: 'About',
                  text: user.about,
                  maxLines: 5,
                  onChanged: (about) {},
                ),
              ],
            ),
          ),
        ),
      );
	  }
	  }
	  );
	  }
}

class LocalUser{
	String name;
	int id;
	String imagePath;
	String email;
	String about;
    bool isDarkMode;
	LocalUser(this.name, this.id, this.imagePath, this.email, this.about, this.isDarkMode);
}