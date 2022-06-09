import 'package:flutter/material.dart';

import './main.dart';
import './addFriends.dart';
import './chats.dart';
import './games.dart';
import './profile.dart';
import './settings.dart';

class FriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Center(child: Text("Friends")),
      ),
    );
  }
}