import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:nus_social/addFriends.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/chats.dart';
import 'package:nus_social/create_profile.dart';
import 'package:nus_social/friends.dart';
import 'package:nus_social/games.dart';
import 'package:nus_social/homePage.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/signInPage.dart';
import 'package:nus_social/signUp.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SIGN UP',
        home: Scaffold(
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddFriendsPage()));
                        },
                        icon: Icon(Icons.person_add, size: 50),
                        label: Text("Add Friends"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GamesPage()));
                        },
                        icon: Icon(Icons.emoji_events_outlined, size: 50),
                        label: Text("Games"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatsPage()));
                        },
                        icon:
                            Icon(Icons.chat_bubble_outline_outlined, size: 50),
                        label: Text("Chats"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FriendsPage()));
                        },
                        icon: Icon(Icons.people_alt, size: 50),
                        label: Text("My Friends"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                        },
                        icon: Icon(Icons.person, size: 50),
                        label: Text("Profile"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        )),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SettingsPage()));
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
