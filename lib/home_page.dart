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

import 'package:nus_social/add_friends.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/chats.dart';
import 'package:nus_social/create_profile.dart';
import 'package:nus_social/friends.dart';
import 'package:nus_social/games.dart';
import 'package:nus_social/home_page.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/sign_in_page.dart';
import 'package:nus_social/sign_up.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 40, 15, 15),
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
                          icon: const Icon(Icons.person_add, size: 50),
                          label: const Text("Add Friends"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                          )),
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GamesPage()));
                          },
                          icon:
                              const Icon(Icons.emoji_events_outlined, size: 50),
                          label: const Text("Games"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                          )),
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatsPage()));
                          },
                          icon: const Icon(Icons.chat_bubble_outline_outlined,
                              size: 50),
                          label: const Text("Chats"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                          )),
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => FriendsPage()));
                          },
                          icon: const Icon(Icons.people_alt, size: 50),
                          label: const Text("My Friends"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                          )),
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                          },
                          icon: const Icon(Icons.person, size: 50),
                          label: const Text("Profile"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                          )),
                      ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SettingsPage()));
                          },
                          icon: const Icon(Icons.app_settings_alt_outlined,
                              size: 50),
                          label: const Text("Settings"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlue,
                          ))
                    ])),
          ),
          ElevatedButton(
            child: const Text('Logout'),
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    ));
  }
}
