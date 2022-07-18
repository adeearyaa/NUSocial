import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:nus_social/constants.dart';
import 'package:nus_social/convoscreen.dart';
import 'package:nus_social/database.dart';
import 'package:nus_social/helperfuncts.dart';
import 'package:nus_social/searchscreen.dart';
import 'package:nus_social/user_class.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String currUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String friendUserId = snapshot.data.docs[index]
                      .data()["chatroomid"]
                      .toString()
                      .replaceAll("_", "")
                      .replaceAll(currUserId, "");
                  String id = snapshot.data.docs[index].data()["chatroomid"];
                  return FutureBuilder(
                      future: UserObj.retrieveUserData(friendUserId),
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                          return ChatRoomTile(friend.name, id);
                        }
                        return Container();
                      });
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    print(Constants.myName);
    databaseMethods.getChatRooms(currUserId).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Chats!",
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: chatRoomList(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            }));
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConversationScreen(chatRoomId)));
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(40)),
                  child: Text("${userName.substring(0, 1).toUpperCase()}"),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(userName)
              ],
            )));
  }
}
