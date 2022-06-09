import 'package:flutter/material.dart';

import './main.dart';
import './chats.dart';
import './friends.dart';
import './games.dart';
import './profile.dart';
import './settings.dart';

class AddFriendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Center(child: Text("AddFriends")),
      ),
    );
  }
}