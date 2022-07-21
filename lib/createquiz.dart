import "package:flutter/material.dart";
import 'package:nus_social/addqns.dart';
import 'package:nus_social/database.dart';
import "package:random_string/random_string.dart";

class CreateQuiz extends StatefulWidget {
  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final _formKey = GlobalKey<FormState>();
  late String quizImageUrl, quizTitle, quizDescription, quizId;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;

  createQuizOnline() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      quizId = randomAlphaNumeric(16);

      Map<String, String> quizMap = {
        "quizId": quizId,
        "quizImgUrl": quizImageUrl,
        "quizTitle": quizTitle,
        "quizDescription": quizDescription
      };

      await databaseMethods.addQuizData(quizMap, quizId);
      setState(() {
        isLoading = false;
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => AddQuestion(quizId)));
      });
    }
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chats!",
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Image Url" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Image Url",
                      ),
                      onChanged: (val) {
                        quizImageUrl = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Quiz Title" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Title",
                      ),
                      onChanged: (val) {
                        quizTitle = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Quiz Description" : null,
                      decoration: InputDecoration(
                        hintText: "Quiz Description",
                      ),
                      onChanged: (val) {
                        quizDescription = val;
                      },
                    ),
                    Spacer(),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Create Quiz'),
                          onPressed: () {
                            createQuizOnline();
                          },
                        ))
                  ]),
                ),
              ));
  }
}
