import 'package:flutter/material.dart';
import 'package:nus_social/database.dart';

class AddQuestion extends StatefulWidget {
  final String quizId;
  AddQuestion(this.quizId);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final _formKey = GlobalKey<FormState>();
  late String question, option1, option2, option3, option4;
  bool isLoading = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  uploadQuizData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4,
      };
      await databaseMethods
          .addQuestionData(questionMap, widget.quizId)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Question Design",
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(children: [
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Question" : null,
                      decoration: InputDecoration(
                        hintText: "Enter question",
                      ),
                      onChanged: (val) {
                        question = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) => val!.isEmpty ? "Enter Option1" : null,
                      decoration: InputDecoration(
                        hintText: "Option1 (correct answer)",
                      ),
                      onChanged: (val) {
                        option1 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Option 2" : null,
                      decoration: InputDecoration(
                        hintText: "Option2",
                      ),
                      onChanged: (val) {
                        option2 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Option 3" : null,
                      decoration: InputDecoration(
                        hintText: "Option3",
                      ),
                      onChanged: (val) {
                        option3 = val;
                      },
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Enter Option 4 " : null,
                      decoration: InputDecoration(
                        hintText: "Option 4",
                      ),
                      onChanged: (val) {
                        option4 = val;
                      },
                    ),
                    Spacer(),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Add Question'),
                          onPressed: () {
                            uploadQuizData();
                          },
                        )),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: ElevatedButton(
                            child: const Text('Submit Quiz'),
                            onPressed: () {
                              Navigator.pop(context);
                            }))
                  ]),
                ),
              ));
  }
}
