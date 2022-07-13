import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:nus_social/constants.dart';
import 'package:nus_social/convoscreen.dart';
import 'package:nus_social/database.dart';
import 'package:nus_social/home_page.dart';

import 'add_friends.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController search = TextEditingController();

  QuerySnapshot<Map<String, dynamic>>? searchSnapshot;

  initiateSearch() {
    databaseMethods.getUserByUsername(search.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot?.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                  userName: searchSnapshot?.docs[index].data()["name"]);
            })
        : Container();
  }

  createRoomAndConvo({required String username}) {
    if (username != Constants.myName) {
      String chatroomid = getChatRoomId(username, Constants.myName);
      List<String?> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomid": chatroomid
      };
      DatabaseMethods().createChatRoom(chatroomid, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatroomid)));
    } else {
      print("you cannot select your own name");
    }
  }

  Widget SearchTile({required String userName}) {
    return Container(
        child: Row(
      children: [
        Column(
          children: [Text(userName)],
        ),
        Spacer(),
        GestureDetector(
            onTap: () {
              createRoomAndConvo(username: userName);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("Message")))
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGN UP',
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'SEARCH',
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
                                builder: (context) => HomePage()));
                          },
                          icon: const Icon(Icons.arrow_back))
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: search,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'find users',
                      ),
                    ),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: ElevatedButton(
                        child: const Text('SEARCH'),
                        onPressed: () {
                          initiateSearch();
                        },
                      )),
                  searchList()
                ])),
          )),
    );
  }
}

getChatRoomId(String? a, String? b) {
  if ((a!.compareTo(b!) > 0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
