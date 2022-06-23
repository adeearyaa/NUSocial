import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/create_profile.dart';
import 'package:nus_social/homePage.dart';
import 'package:nus_social/signInPage.dart';
import 'package:nus_social/main.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'signInPage.dart';
import 'homePage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserObj userObj = findUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.create_outlined),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateProfile()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text(userObj.userName),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(userObj.name),
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: Text(userObj.course),
          ),
          ListTile(
            leading: const Icon(Icons.numbers_outlined),
            title: Text(userObj.year.toString()),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text(userObj.bio),
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

  Stream<List<UserObj>> readUsers() => FirebaseFirestore.instance
      .collection('usersInfo')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserObj.fromJson(doc.data())).toList());

  UserObj findUser() {
    final userRef = FirebaseAuth.instance.currentUser;

    if (userRef != null) {
      final userID = userRef.uid;
      print(userID);

      FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(userID)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data();
          if (data != null) {
            return UserObj.fromJson(data);
          } else {
            return UserObj.nullUser();
          }
        } else {
          return UserObj.nullUser();
        }
      });
    }

    return UserObj.nullUser();
  }
}
