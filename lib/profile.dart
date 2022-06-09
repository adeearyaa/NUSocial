import 'package:flutter/material.dart';

import './main.dart';
import './addFriends.dart';
import './chats.dart';
import './friends.dart';
import './games.dart';
import './settings.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Center(child: Text("Profile")),
      ),
    );
  }
}