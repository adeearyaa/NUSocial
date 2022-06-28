import 'package:flutter/material.dart';

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

class ProfilePageWidget extends StatefulWidget {
  const ProfilePageWidget({Key? key}) : super(key: key);

  @override
  State<ProfilePageWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageWidget> {
  UserObj userObj = UserObj.nullUser();

  void updateProfile() {
    userObj = UserObj.findUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userRef = FirebaseAuth.instance.currentUser;
    if (userRef == null) {
      return profileDetails(context, UserObj.nullUser());
    }

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('usersInfo')
            .doc(userRef.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return profileDetails(context, UserObj.nullUser());
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return profileDetails(context, UserObj.nullUser());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return profileDetails(context, UserObj.fromJson(data));
          }

          return loadingScreen(context);
        });
  }

  Widget profileDetails(BuildContext context, UserObj userObj) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.create_outlined),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateProfileWidget()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          profileImgPreview(context, userObj.imgName),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text('Username: ' + userObj.userName),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('Displayname: ' + userObj.name),
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined),
            title: Text('Course: ' + userObj.course),
          ),
          ListTile(
            leading: const Icon(Icons.numbers_outlined),
            title: Text('Year of Study: ' + userObj.year.toString()),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: Text('Bio: ' + userObj.bio),
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

Stream<List<UserObj>> readUsers() => FirebaseFirestore.instance
    .collection('usersInfo')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => UserObj.fromJson(doc.data())).toList());

Future profileImgGetter(String imgName) async {
  final ref = FirebaseStorage.instance.ref().child('profileImages/$imgName');
  String url = await ref.getDownloadURL();
  return url;
}

Widget profileImgPreview(BuildContext context, String imgName) {
  return FutureBuilder(
      future: profileImgGetter(imgName),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return CircleAvatar(
            foregroundImage: AssetImage('assets/images/avatar_blank.jpg'),
            radius: 100,
          );
        }

        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          String? url = snapshot.data;
          if (url != null) {
            return CircleAvatar(
              foregroundImage: NetworkImage(url),
              radius: 100,
            );
          }
        }

        return CircleAvatar(
          foregroundImage: AssetImage('assets/images/avatar_blank.jpg'),
          radius: 100,
        );
      });
}
