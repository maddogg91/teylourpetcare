import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'database.dart';
import 'newMessageScreen.dart';

class NewMessageProvider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<LocalUser>>.value(
      value: Database.streamUsers(),
      child: NewMessageScreen(),
    );
  }
}	