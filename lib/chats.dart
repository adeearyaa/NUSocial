import 'package:flutter/material.dart';

import './main.dart';
import './addFriends.dart';
import './friends.dart';
import './games.dart';
import './profile.dart';
import './settings.dart';

class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConvPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
          if (value == 1)
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => GamesPage()));
          if (value == 2) ;
        },
      ),
    );
  }
}

class ConvPage extends StatefulWidget {
  @override
  _ConvPageState createState() => _ConvPageState();
}

class _ConvPageState extends State<ConvPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(child: Text("Chat")),
      ),
    );
  }
}
