import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:nus_social/constants.dart';
import 'package:nus_social/convoscreen.dart';
import 'package:nus_social/database.dart';
import 'package:nus_social/home_page.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/user_class.dart';

import 'add_friends.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

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

  Widget friendDetailsCard(BuildContext context, String friendUserId) {
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
          return ExpansionTile(
            leading: CircleAvatar(foregroundImage: image),
            title: Text(friend.name),
            children: [
              ListTile(
                title: Text(friend.course + ' Year ' + friend.year.toString()),
                subtitle: Text(friend.bio),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      iconSize: 30,
                      color: Colors.deepOrange,
                      tooltip: 'Send a Message.',
                      icon: const Icon(Icons.message_outlined),
                      onPressed: () {
                        createRoomAndConvo(username: friend.name);
                      },
                    ),
                    IconButton(
                      iconSize: 30,
                      color: Colors.deepOrange,
                      tooltip: 'Invite to a Game.',
                      icon: const Icon(Icons.videogame_asset_rounded),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  String currUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with friends!'),
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
                        return friendDetailsCard(context, userId);
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
}

getChatRoomId(String? a, String? b) {
  if ((a!.compareTo(b!) > 0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
