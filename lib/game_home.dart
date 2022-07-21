import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/quiz/friends_quiz.dart';
import 'package:nus_social/quiz/quiz_home.dart';
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

import 'package:nus_social/home_page.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/sign_in_page.dart';
import 'package:nus_social/sign_up.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Games'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          ExpansionTile(
            leading: const Icon(
              Icons.quiz_outlined,
              color: Colors.deepOrange,
            ),
            title: const Text('Quizzes'),
            children: <Widget>[
              ListTile(
                title: const Text('Make your own quizzes'),
                leading: const Icon(
                  Icons.create_outlined,
                  color: Colors.deepOrange,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow_outlined),
                  color: Colors.deepOrange,
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => QuizHome()));
                  },
                ),
              ),
              ListTile(
                title: const Text("Try your friend's quizzes"),
                leading: const Icon(
                  Icons.person_outline_outlined,
                  color: Colors.deepOrange,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow_outlined),
                  color: Colors.deepOrange,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FriendsQuizHome()));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 300,
          ),
          const Text('More games coming soon!'),
        ],
      )),
    );
  }
}
