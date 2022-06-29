import 'package:flutter/material.dart';

import './main.dart';
import './addFriends.dart';
import './chats.dart';
import './friends.dart';
import './profile.dart';
import './settings.dart';
import 'homePage.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Center(child: Text("Games")),
      ),
    );
  }
}
