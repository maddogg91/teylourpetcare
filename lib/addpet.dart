import 'package:flutter/material.dart';


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
