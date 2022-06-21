import 'package:flutter/material.dart';

import './main.dart';
import './addFriends.dart';
import './chats.dart';
import './friends.dart';
import './games.dart';
import './profile.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Center(child: Text("Settings")),
      ),
    );
  }
}
