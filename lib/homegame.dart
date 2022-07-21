import "package:flutter/material.dart";
import 'package:nus_social/createquiz.dart';
import 'package:nus_social/database.dart';
import 'package:nus_social/playquiz.dart';

class HomeGame extends StatefulWidget {
  @override
  _HomeGameState createState() => _HomeGameState();
}

class _HomeGameState extends State<HomeGame> {
  Stream? quizStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Widget quizList() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
          stream: quizStream,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return QuizTile(
                          imgUrl:
                              snapshot.data.docs[index].data()["quizImgUrl"],
                          title: snapshot.data.docs[index].data()["quizTitle"],
                          desc: snapshot.data.docs[index]
                              .data()["quizDescription"],
                          quizId: snapshot.data.docs[index].data()["quizId"]);
                    });
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
