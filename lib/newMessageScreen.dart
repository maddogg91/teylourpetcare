import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'userRow.dart';

class NewMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final List<LocalUser> userDirectory = Provider.of<List<LocalUser>>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Select Contact')),
      body: userDirectory != null
          ? ListView(
              shrinkWrap: true, children: getListViewItems(userDirectory, user))
          : Container(),
    );
  }

  List<Widget> getListViewItems(List<LocalUser> userDirectory, User user) {
    final List<Widget> list = <Widget>[];
    for (LocalUser contact in userDirectory) {
      if (contact.id != user.uid) {
        list.add(UserRow(uid: user.uid, contact: contact));
        list.add(Divider(thickness: 1.0));
      }
    }
    return list;
  }
}