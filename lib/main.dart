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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const primaryColourOrange = Colors.deepOrange;
  static const primaryColourBlue = Colors.lightBlue;

  static const _title = 'NUSocial';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
              create: (context) =>
                  context.read<AuthenticationService>().authStateChanges,
              initialData: null),
        ],
        child: MaterialApp(
          title: _title,
          home: Scaffold(
            appBar: AppBar(
              title: const Text(
                _title,
                style: TextStyle(fontSize: 30),
              ),
              backgroundColor: Colors.deepOrange,
            ),
            body: const AuthenticationWrapper(),
          ),
        ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return HomePage();
    }

    return MyStatefulWidget();
  }
}

class UserObj {
  String id;
  String userName;
  String name;
  String course;
  int year;
  String bio;
  String imgName;
  static const ImageProvider emptyAvatarImage =
      AssetImage('assets/images/avatar_blank.jpg');

  UserObj({
    this.id = '',
    required this.userName,
    required this.name,
    required this.course,
    required this.year,
    required this.bio,
    required this.imgName,
  });

  //Converts user object to json file to store in firebase collections.
  Map<String, dynamic> toJson() => {
        'id': this.id,
        'userName': this.userName,
        'name': this.name,
        'course': this.course,
        'year': this.year,
        'bio': this.bio,
        'imgName': this.imgName,
      };
  //Converts json from firebase collections to user object.
  static UserObj fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserObj.nullUser();
    }

    return UserObj(
      id: json['id'],
      userName: json['userName'],
      name: json['name'],
      course: json['course'],
      year: json['year'],
      bio: json['bio'],
      imgName: json['imgName'],
    );
  }

  //Empty user object.
  static UserObj nullUser() => UserObj(
      id: '',
      userName: '',
      name: '',
      course: '-',
      year: 0,
      bio: '',
      imgName: '');

  //Empty map with an empty user object and a default avatar picture.
  static Map<String, dynamic> emptyMap() => {
        'user': UserObj.nullUser(),
        'image': UserObj.emptyAvatarImage,
      };

  static UserObj findUser() {
    final userRef = FirebaseAuth.instance.currentUser;

    if (userRef != null) {
      final userID = userRef.uid;
      FirebaseFirestore.instance
          .collection('usersInfo')
          .doc(userID)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data();
          if (data != null) {
            print('User Found');
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

  //Retrives user object and profile asynchronously picture and stores it in a map.
  static Future<Map<String, dynamic>> retrieveUserData(String userId) async {
    UserObj user = await FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(userId)
        .get()
        .then((mapSnapshot) => UserObj.fromJson(mapSnapshot.data()));
    String imgName = user.imgName;
    final imgRef =
        FirebaseStorage.instance.ref().child('profileImages/$imgName');
    String imgUrl = await imgRef.getDownloadURL();
    return {'user': user, 'image': NetworkImage(imgUrl)};
  }

  //Retrives user profile image only using the image name.
  static Future<ImageProvider> retrieveUserImage(String imgName) async {
    final imgRef =
        FirebaseStorage.instance.ref().child('profileImages/$imgName');
    String imgUrl = await imgRef.getDownloadURL();
    return NetworkImage(imgUrl);
  }

  //Retrives user friends document on firestore.
  static Future<Map<String, dynamic>> retrieveUserFriends(String userId) async {
    final friendsDoc = await FirebaseFirestore.instance
        .collection('usersFriends')
        .doc(userId)
        .get();
    return friendsDoc.data()!;
  }
}

//Dummy loading screen.
Widget loadingScreen(BuildContext context) {
  return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Loading...'),
            backgroundColor: Colors.deepOrange,
          ),
          body: const Center(
            widthFactor: 10,
            heightFactor: 10,
            child: CircularProgressIndicator(),
          )));
}
