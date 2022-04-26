import 'convo.dart';
import 'user.dart';
import 'convoWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'newMessageProvider.dart';

class HomeBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User firebaseUser = Provider.of<User>(context);
    final List<Convo> _convos = Provider.of<List<Convo>>(context);
    final List<LocalUser> _users = Provider.of<List<LocalUser>>(context);
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(firebaseUser.displayName, style: TextStyle(fontSize: 18)),
          IconButton(
              onPressed: () => createNewConvo(context),
              icon: Icon(Icons.add, size: 30))
        ],
      )),
      body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: getWidgets(context, firebaseUser, _convos, _users))
    );
  }

  void createNewConvo(BuildContext context) {
    Navigator.of(context).push<dynamic>(MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => NewMessageProvider()));
  }

  Map<String, LocalUser> getUserMap(List<LocalUser> users) {
    final Map<String, LocalUser> userMap = Map();
    for (LocalUser u in users) {
      userMap[u.id] = u;
    }
    return userMap;
  }

  List<Widget> getWidgets(
      BuildContext context, User user, List<Convo> _convos, List<LocalUser> _users) {
    final List<Widget> list = <Widget>[];
    if (_convos != null && _users != null && user != null) {
      final Map<String, LocalUser> userMap = getUserMap(_users);
      for (Convo c in _convos) {
        if (c.userIds[0] == user.uid) {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[1]],
              lastMessage: c.lastMessage));
        } else {
          list.add(ConvoListItem(
              user: user,
              peer: userMap[c.userIds[0]],
              lastMessage: c.lastMessage));
        }
      }
    }

    return list;
  }
}