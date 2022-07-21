import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/quiz/play_quiz.dart';
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
import 'package:nus_social/quiz/question_class.dart';
import 'package:nus_social/database.dart';
import 'package:nus_social/quiz/quiz_play_widget.dart';
import 'package:nus_social/quiz/quiz_results.dart';

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
import 'package:nus_social/user_class.dart';
import "package:nus_social/searchscreen.dart";

class FriendsQuizHome extends StatelessWidget {
  String currUserId = FirebaseAuth.instance.currentUser!.uid;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: UserObj.retrieveUserFriends(currUserId),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return Container(
                    child: const Text('Something went wrong, oops!'),
                  );
                }
                if (snapshot.hasError) {
                  return Container(
                    child: Text(snapshot.error.toString()),
                  );
                }
                List<dynamic>? friendsList = snapshot.data!['friends'];

                if (friendsList != null) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: friendsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        String userId = friendsList[index];
                        return friendQuizCard(context, userId);
                      },
                    ),
                  );
                }
                return Column(
                  children: <Widget>[
                    const SizedBox(height: 200),
                    const Icon(Icons.person_add_alt_1_outlined, size: 200.0),
                    const Center(
                        child: Text(
                            'You have no friends yet, go add some friends!')),
                  ],
                );
              }
              return Expanded(child: loadingScreen(context));
            },
          ),
        ],
      ),
    );
  }

  Widget friendQuizCard(BuildContext context, String friendUserId) {
    return FutureBuilder(
      future: UserObj.retrieveUserData(friendUserId),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return Container(
              child: Text('Something went wrong, oops!'),
            );
          }
          if (snapshot.hasError) {
            return Container(
              child: Text(snapshot.error.toString()),
            );
          }
          UserObj friend = snapshot.data!['user'];
          NetworkImage image = snapshot.data!['image'];
          return ListTile(
            leading: CircleAvatar(foregroundImage: image),
            title: Text(friend.name),
            trailing: IconButton(
              iconSize: 30,
              color: Colors.deepOrange,
              tooltip: 'Try his quizzes!',
              icon: const Icon(Icons.quiz_outlined),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FriendsQuizList(
                        authorId: friend.id, authorName: friend.name)));
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class FriendsQuizList extends StatefulWidget {
  final String authorId;
  final String authorName;
  const FriendsQuizList(
      {Key? key, required this.authorId, required this.authorName})
      : super(key: key);
  @override
  _FriendsQuizListState createState() => _FriendsQuizListState();
}

class _FriendsQuizListState extends State<FriendsQuizList> {
  Stream? quizStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState() {
    databaseMethods.getQuizData().then((val) {
      setState(() {
        quizStream = val;
      });
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes by ' + widget.authorName),
        backgroundColor: Colors.deepOrange,
      ),
      body: quizList(),
    );
  }

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
          stream: quizStream,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            List<dynamic> quizzes = snapshot.data.docs
                .where((doc) => doc.data()["quizAuthor"] == widget.authorId)
                .toList();

            if (quizzes.isEmpty) {
              return Column(
                children: <Widget>[
                  const SizedBox(height: 200),
                  const Icon(Icons.playlist_remove_outlined, size: 200.0),
                  const Center(
                      child: Text(
                          'Seems like your friend has not made any quizzes yet!')),
                ],
              );
            }
            return Column(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        return QuizTile(
                          imgUrl: quizzes[index].data()["quizImgUrl"],
                          title: quizzes[index].data()["quizTitle"],
                          desc: quizzes[index].data()["quizDescription"],
                          quizId: quizzes[index].data()["quizId"],
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imgUrl;
  final String title;
  final String desc;
  final String quizId;

  QuizTile(
      {required this.imgUrl,
      required this.title,
      required this.desc,
      required this.quizId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayQuiz(quizId)));
      },
      child: Container(
          margin: EdgeInsets.only(bottom: 8),
          height: 150,
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imgUrl,
                    width: MediaQuery.of(context).size.width - 48,
                    fit: BoxFit.cover,
                  )),
              Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 6),
                      Text(desc,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400))
                    ],
                  ))
            ],
          )),
    );
  }
}
