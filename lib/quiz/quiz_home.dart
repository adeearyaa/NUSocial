import "package:flutter/material.dart";
import 'package:nus_social/main.dart';
import 'package:nus_social/quiz/create_quiz.dart';
import 'package:nus_social/database.dart';
import 'package:nus_social/quiz/play_quiz.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class QuizHome extends StatefulWidget {
  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  Stream? quizStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String currUserId = FirebaseAuth.instance.currentUser!.uid;

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
                .where((doc) => doc.data()["quizAuthor"] == currUserId)
                .toList();
            if (quizzes.isEmpty) {
              return Column(
                children: <Widget>[
                  const SizedBox(height: 200),
                  const Icon(Icons.playlist_remove_outlined, size: 200.0),
                  const Center(
                      child: Text(
                          "You haven't made any quizzes yet, try making some!")),
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
                        List<dynamic> quizzes = snapshot.data.docs
                            .where(
                                (doc) => doc.data()["quizAuthor"] == currUserId)
                            .toList();

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

  @override
  void initState() {
    databaseMethods.getQuizData().then((val) {
      setState(() {
        quizStream = val;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quizzes!",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: quizList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => CreateQuiz())));
        },
      ),
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
