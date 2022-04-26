import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


User loggedinUser;
FirebaseFirestore fs = FirebaseFirestore.instance;
String admin;
String email;
LocalUser user;
List<LocalPet> yourPets= List.empty(growable:true);
String uid;

class PetScreen extends StatefulWidget {
 @override
  _PetScreenState createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
@override
  Widget build(BuildContext context){
  
		return StreamBuilder<QuerySnapshot>(
		stream: fs.collection('pets').snapshots(),
		builder: (context, snap){
			if(!snap.hasData){
			print("No data");
			return Scaffold();
			}
			
			else if(snap.hasData){
			
			List<DocumentSnapshot> documents= snap.data.docs;
			print(user.id);
			for(DocumentSnapshot doc in documents){
				String petId= doc.id.replaceAll(' ','');
				if(user.id== petId){
					if(doc["1"].isEmpty){
						 return Scaffold(
      appBar: AppBar(
        title: const Text('Teylours Pet Care'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Add a pet',
            onPressed: () {
              return MaterialApp(
					title: 'Add pet',
					theme: ThemeData(
					primarySwatch: Colors.blue,
					),
				debugShowCheckedModeBanner: false,
				home: AddPet(),
				);
            },
          ),
          
        ],
      ),
      body: const Center(
        child: Text(
          'No Pet exists in the system',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
					}
					
					else{
					LocalPet pet= LocalPet(doc["1"]["petName"], doc["1"]["breed1"], doc["1"]["breed2"],
					doc["1"]["desc"], doc["1"]["image"], doc["1"]["age"]);
					yourPets.add(pet);
					return MaterialApp(
					title: 'PetScreen',
					theme: ThemeData(
					primarySwatch: Colors.blue,
					),
				debugShowCheckedModeBanner: false,
				home: HomePageWidget(),
				);
					}
					
				}
			}
			return Scaffold();
			}
			}
		);
  
  }
 
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFF29AEC),
        automaticallyImplyLeading: false,
        title: Text(
          'Teylour\'s Petcare',
        ),
        actions: [
          IconButton(
         
           
            icon: Icon(
              Icons.add_alert,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              print('Add pressed ...');
            },
          ),
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: Colors.pink[70],
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
				Expanded(
				child: ListView.builder(
				itemCount: yourPets.length,
				itemBuilder:(context,index){
				   return 
				 Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(
                      yourPets[index].image,
                    ),
                  ),
                  Text(
                    yourPets[index].name,
                  ),
                ],
			
              );
				}
			
			)
             ),
            ],
          ),
        ),
      ),
    );
  }
}




class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
		uid= loggedinUser.uid;
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context){
  

  
return StreamBuilder<QuerySnapshot>(
		
		stream: fs.collection('client').snapshots(),
		builder: (context, snapshot){
			if(!snapshot.hasData){
			
			return Scaffold();
			}
			
			else if(snapshot.hasData){
			
			List<DocumentSnapshot> documents= snapshot.data.docs;
			for(DocumentSnapshot doc in documents){
				if(uid== doc.get("uid")){
				 user= LocalUser(doc.get("firstname")+" " + doc.get("lastname")
				,doc.get("id"), doc.get("imagePath"), doc.get("about")) ;
				}
				
			}
			return MaterialApp(
					title: 'PetScreen',
					theme: ThemeData(
					primarySwatch: Colors.blue,
					),
				debugShowCheckedModeBanner: false,
				home: PetScreen(),
				);
		}
		}
		);
	
  }

  
}

class LocalUser{
	String name;
	String id;
	String imagePath;
	String about;
	LocalUser(this.name, this.id, this.imagePath,this.about);
}

class LocalPet{
	String name;
	String breed;
	String secondaryBreed;
	String desc;
	String image;
	int age;
	LocalPet(this.name, this.breed, this.secondaryBreed, this.desc, this.image, this.age);
}


class AddPet extends StatefulWidget {
  @override
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  TextEditingController ageController;
  TextEditingController nameController;
  TextEditingController breedController;
  TextEditingController breed2Controller;
  TextEditingController descController;
  TextEditingController urlController;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController();
    nameController = TextEditingController();
    breedController = TextEditingController();
    breed2Controller = TextEditingController();
    descController = TextEditingController();
    urlController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFFF29AEC),
        automaticallyImplyLeading: false,
        leading: IconButton(
          
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            print('Back pressed ...');
          },
        ),
        title: Text(
          'Add a pet',
 
        ),
        actions: [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Container(
                      width: 200,
                      child: TextFormField(
                        controller: nameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: 'Pet\'s Name',
                          hintText: '[Some hint text...]',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: ageController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Age of Pet',
                  hintText: '[Some hint text...]',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: breedController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Primary Breed',
                  hintText: '[Some hint text...]',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: breed2Controller,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Secondary Breed',
                  hintText: '[Some hint text...]',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: descController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Describe your pet',
                  hintText: '[Some hint text...]',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                ),
                maxLines: 10,
              ),
              TextFormField(
                controller: urlController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Add a picture (url)',
                  hintText: '[Some hint text...]',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0x00000000),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4.0),
                      topRight: Radius.circular(4.0),
                    ),
                  ),
                ),
              ),
         
            ],
          ),
        ),
      ),
    );
  }
}

