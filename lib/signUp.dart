import 'package:flutter/material.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/create_profile.dart';
import 'package:nus_social/homePage.dart';
import 'package:nus_social/signInPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'main.dart';
import 'signInPage.dart';
import 'homePage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController newid = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController secondpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGN UP',
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'SIGN UP',
              style: TextStyle(fontSize: 30),
            ),
            backgroundColor: Colors.deepOrange,
          ),
          body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => MyApp()));
                        },
                        icon: Icon(Icons.arrow_back))
                  ],
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'NEW ACCOUNT',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: newid,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Choose a new username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextField(
                    obscureText: true,
                    controller: newpassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Password',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextField(
                    obscureText: true,
                    controller: secondpassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Confirm account'),
                      onPressed: () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: newid.text, password: newpassword.text)
                            .then((value) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CreateProfile()));
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                      },
                    )),
              ]))),
    );
  }
}
