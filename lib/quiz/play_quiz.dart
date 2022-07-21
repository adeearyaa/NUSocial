import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nus_social/quiz/question_class.dart';
import 'package:nus_social/database.dart';
import 'package:nus_social/quiz/quiz_play_widget.dart';
import 'package:nus_social/quiz/quiz_results.dart';

class PlayQuiz extends StatefulWidget {
  final String quizId;
  PlayQuiz(this.quizId);
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _PlayQuizState extends State<PlayQuiz> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot? questionsSnapshot;

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.get("question");

    List<String> options = [
      questionSnapshot.get("option1"),
      questionSnapshot.get("option2"),
      questionSnapshot.get("option3"),
      questionSnapshot.get("option4"),
    ];

    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.get("option1");
    questionModel.answered = false;

    return questionModel;
  }

  @override
  void initState() {
    print("${widget.quizId}");
    databaseMethods.getQuizDataQns(widget.quizId).then((val) {
      questionsSnapshot = val;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = questionsSnapshot!.docs.length;
      print("$total this is total");

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QUIZ TIME!",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Column(children: [
          questionsSnapshot?.docs == null
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: questionsSnapshot!.docs.length,
                  itemBuilder: (context, index) {
                    return QuizPlayTile(
                      questionModel: getQuestionModelFromDatasnapshot(
                          questionsSnapshot!.docs[index]),
                      index: index,
                    );
                  },
                )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Results(
                        correct: _correct,
                        incorrect: _incorrect,
                        total: total)));
          }),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({required this.questionModel, required this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = " ";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Q${widget.index + 1} ${widget.questionModel.question}",
            style: TextStyle(fontSize: 17, color: Colors.black87)),
        SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.answered) {
              if (widget.questionModel.option1 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option1;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option1;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
            }
          },
          child: OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option1,
            option: "A",
            optionSelected: optionSelected,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.answered) {
              if (widget.questionModel.option2 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option2;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option2;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
            }
          },
          child: OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option2,
            option: "B",
            optionSelected: optionSelected,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.answered) {
              if (widget.questionModel.option3 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option3;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option3;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
            }
          },
          child: OptionTile(
            correctAnswer: widget.questionModel.correctOption,
            description: widget.questionModel.option3,
            option: "C",
            optionSelected: optionSelected,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        GestureDetector(
          onTap: () {
            if (!widget.questionModel.answered) {
              if (widget.questionModel.option4 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option4;
                widget.questionModel.answered = true;
                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              } else {
                optionSelected = widget.questionModel.correctOption;
                widget.questionModel.answered = true;
                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
            }
          },
          child: OptionTile(
            correctAnswer: widget.questionModel.option1,
            description: widget.questionModel.option4,
            option: "D",
            optionSelected: optionSelected,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ]),
    );
  }
}
