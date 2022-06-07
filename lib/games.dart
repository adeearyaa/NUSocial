import 'package:flutter/material.dart';

import './main.dart';
import './addFriends.dart';
import './chats.dart';
import './friends.dart';
import './profile.dart';
import './settings.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: MyApp.primaryColourOrange,
      ),
      body: Container(
        child: Center(child: Text("Games")),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.blueGrey,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_customize_outlined, size: 20),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined, size: 20),
            label: "Games",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_outlined, size: 20),
            label: "Chats",
          ),
        ],
        onTap: (value) {
          if (value == 0)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => WelcomePage()));
          if (value == 1) ;
          if (value == 2)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ChatsPage()));
        },
      ),
    );
  }
}
