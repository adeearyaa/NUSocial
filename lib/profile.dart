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

import 'package:nus_social/create_profile.dart';
import 'package:nus_social/friends.dart';
import 'package:nus_social/games.dart';
import 'package:nus_social/home_page.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/sign_in_page.dart';
import 'package:nus_social/sign_up.dart';
import 'package:nus_social/user_class.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void updateProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userRef = FirebaseAuth.instance.currentUser;
    return FutureBuilder(
        future: UserObj.retrieveUserData(userRef!.uid),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasError) {
            return profileDetailsWidget(context, UserObj.emptyMap());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return profileDetailsWidget(context, UserObj.emptyMap());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return profileDetailsWidget(context, snapshot.data!);
          }

          return loadingScreen(context);
        });
  }

  Widget profileDetailsWidget(BuildContext context, Map<String, dynamic> map) {
    UserObj user = map['user'];
    ImageProvider image = map['image'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.create_outlined),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateProfilePage()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          CircleAvatar(
            foregroundImage: image,
            radius: 100,
          ),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text('Username: ' + user.userName),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Displayname: ' + user.name),
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: Text('Course: ' + user.course),
          ),
          ListTile(
            leading: const Icon(Icons.numbers_outlined),
            title: Text('Year of Study: ' + user.year.toString()),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text('Bio: ' + user.bio),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ElevatedButton(
              child: const Text('Refresh Profile'),
              onPressed: () {
                setState(() {});
              },
            ),
          ),
        ],
      )),
    );
  }
}
