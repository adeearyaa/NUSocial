import 'package:flutter/material.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/homePage.dart';
import 'package:nus_social/signInPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication.dart';
import 'signInPage.dart';
import 'homePage.dart';

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
      return WelcomePage();
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

  UserObj({
    this.id = '',
    required this.userName,
    required this.name,
    required this.course,
    required this.year,
    required this.bio,
    required this.imgName,
  });

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'userName': this.userName,
        'name': this.name,
        'course': this.course,
        'year': this.year,
        'bio': this.bio,
        'imgName': this.imgName,
      };

  static UserObj fromJson(Map<String, dynamic> json) => UserObj(
        id: json['id'],
        userName: json['userName'],
        name: json['name'],
        course: json['course'],
        year: json['year'],
        bio: json['bio'],
        imgName: json['imgName'],
      );

  static UserObj nullUser() => UserObj(
      id: '-',
      userName: '-',
      name: 'User not Found',
      course: '-',
      year: -1,
      bio: '-',
      imgName: '-');

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
}

Widget loadingScreen(BuildContext context) {
  return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Loading...'),
            backgroundColor: Colors.deepOrange,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Center(
                  child: Text(
                "Loading...",
                style: TextStyle(fontSize: 25),
              )),
              const SizedBox(
                height: 200.0,
                width: 200.0,
                child: CircularProgressIndicator(),
              ),
            ],
          )));
}
