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
import 'package:email_validator/email_validator.dart';

import 'package:nus_social/add_friends.dart';
import 'package:nus_social/authentication.dart';

import 'package:nus_social/create_profile.dart';
import 'package:nus_social/friends.dart';

import 'package:nus_social/home_page.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/sign_in_page.dart';
import 'package:nus_social/sign_up.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyApp()));
                          },
                          icon: const Icon(Icons.arrow_back))
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
                    child: TextFormField(
                      controller: newid,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your E-Mail address',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid E-Mail address'
                              : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: TextFormField(
                      obscureText: true,
                      controller: newpassword,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'New Password',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (pass) => pass!.length < 6
                          ? 'Password needs to be at least 6 characters long'
                          : null,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: TextFormField(
                      obscureText: true,
                      controller: secondpassword,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Confirm Password',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (pass) => pass == secondpassword.text
                          ? 'Password does not match'
                          : null,
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
                                builder: (context) => CreateProfilePage()));
                          }).onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                        },
                      )),
                ])),
          )),
    );
  }
}
