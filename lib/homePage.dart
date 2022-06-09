

import 'package:flutter/material.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:provider/provider.dart';

import 'addFriends.dart';
import 'chats.dart';
import 'friends.dart';
import 'games.dart';
import 'main.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SIGN UP',
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'DASHBOARD',
              style: TextStyle(fontSize: 20),
            ),
            backgroundColor: Colors.deepOrange,
          ),
          body: Padding(
              padding: const EdgeInsets.fromLTRB(15, 80, 15, 15),
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(15),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => AddFriendsPage()));
                        },
                        icon: Icon(Icons.person_add, size: 50),
                        label: Text("Add Friends"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => GamesPage()));
                        },
                        icon: Icon(Icons.emoji_events_outlined, size: 50),
                        label: Text("Games"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ChatsPage()));
                        },
                        icon:
                        Icon(Icons.chat_bubble_outline_outlined, size: 50),
                        label: Text("Chats"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => FriendsPage()));
                        },
                        icon: Icon(Icons.people_alt, size: 50),
                        label: Text("My Friends"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProfilePage()));
                        },
                        icon: Icon(Icons.person, size: 50),
                        label: Text("Profile"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SettingsPage()));
                        },
                        icon: Icon(Icons.app_settings_alt_outlined, size: 50),
                        label: Text("Settings"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        ))
                  ])),
          floatingActionButton: Container(
              height: 50,
              width: 100,
              child: ElevatedButton(
                child: const Text('Logout'),
                onPressed: () {
                  context.read<AuthenticationService>().signOut();
                },
              )),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
        ));
  }
}