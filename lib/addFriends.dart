import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:nus_social/addFriends.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/chats.dart';
import 'package:nus_social/create_profile.dart';
import 'package:nus_social/friends.dart';
import 'package:nus_social/games.dart';
import 'package:nus_social/homePage.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/signInPage.dart';
import 'package:nus_social/signUp.dart';

class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({Key? key}) : super(key: key);

  @override
  State<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  int _selectedIndex = 0;
  String currUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
        backgroundColor: Colors.deepOrange,
      ),
      body: selectedPage(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrange,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search_outlined),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add_outlined),
            label: 'Friend Requests',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget selectedPage(int index) {
    List<Widget> pages = <Widget>[
      searchBody(),
      requestsBody(),
    ];
    return pages.elementAt(index);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget searchBody() {
    return StreamBuilder<List<UserObj>>(
        stream: getUsersList(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserObj>> usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.active) {
            if (!usersSnapshot.hasData) {
              return Container(
                child: const Text('Something went wrong, oops!'),
              );
            }
            if (usersSnapshot.hasError) {
              return Container(
                child: Text(usersSnapshot.error.toString()),
              );
            }
            List<UserObj> usersList = usersSnapshot.data!;
            return FutureBuilder(
              future: UserObj.retrieveUserFriends(currUserId),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> friendsSnapshot) {
                if (friendsSnapshot.connectionState == ConnectionState.done) {
                  if (!friendsSnapshot.hasData) {
                    return Container(
                      child: const Text('Something went wrong, oops!'),
                    );
                  }
                  if (friendsSnapshot.hasError) {
                    return Container(
                      child: Text(friendsSnapshot.error.toString()),
                    );
                  }
                  List<dynamic>? rawList = friendsSnapshot.data!['friends'];
                  if (rawList != null) {
                    List<String>? friendsList =
                        List<String>.from(rawList as List);
                    usersList
                        .removeWhere((user) => friendsList.contains(user.id));
                  }
                  return searchBodyList(usersList: usersList);
                }
                return loadingScreen(context);
              },
            );
          }
          return loadingScreen(context);
        });
  }

  Stream<List<UserObj>> getUsersList() {
    Stream<List<UserObj>> usersList = FirebaseFirestore.instance
        .collection('usersInfo')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserObj.fromJson(doc.data()))
            .where((user) => user.id != currUserId)
            .toList());
    return usersList;
  }

  Widget requestsBody() {
    String currUserId = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder(
      future: UserObj.retrieveUserFriends(currUserId),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
          List<dynamic>? requestsList = snapshot.data!['requests'];

          if (requestsList != null) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: requestsList.length,
              itemBuilder: (BuildContext context, int index) {
                String userId = requestsList[index];
                return friendRequestCard(senderUserId: userId);
              },
            );
          }

          return const Center(
            child: Text('No friend requests for now.'),
          );
        }
        return loadingScreen(context);
      },
    );
  }
}

class searchBodyList extends StatefulWidget {
  final List<UserObj> usersList;
  const searchBodyList({Key? key, required this.usersList}) : super(key: key);
  @override
  State<searchBodyList> createState() => _searchBodyListState();
}

class _searchBodyListState extends State<searchBodyList> {
  String currUserId = FirebaseAuth.instance.currentUser!.uid;
  List<UserObj> filteredList = [];

  initState() {
    filteredList = widget.usersList;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) => runListFilter(value),
          decoration: const InputDecoration(
              labelText: 'Search by name', suffixIcon: Icon(Icons.search)),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: filteredList.length,
          itemBuilder: (BuildContext context, int index) {
            UserObj user = filteredList[index];

            return ExpansionTile(
              leading: displayUserProfilePicture(context, user.imgName),
              title: Text(user.name),
              children: <Widget>[
                ListTile(
                    title: Text(user.course + ' Year ' + user.year.toString()),
                    subtitle: Text(user.bio),
                    trailing: sendRequestButton(
                        senderUserId: currUserId, recieverUserId: user.id)),
              ],
            );
          },
        ),
      ],
    );
  }

  void runListFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      filteredList = widget.usersList;
    } else {
      filteredList = widget.usersList
          .where((user) =>
              user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {});
  }

  Widget displayUserProfilePicture(BuildContext context, String imgName) {
    return FutureBuilder(
        future: UserObj.retrieveUserImage(imgName),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const CircleAvatar(
                foregroundImage: UserObj.emptyAvatarImage,
              );
            }
            if (snapshot.hasError) {
              return const CircleAvatar(
                foregroundImage: UserObj.emptyAvatarImage,
              );
            }
            return CircleAvatar(foregroundImage: snapshot.data!);
          }
          return const CircularProgressIndicator();
        });
  }
}

class sendRequestButton extends StatefulWidget {
  final String senderUserId;
  final String recieverUserId;
  const sendRequestButton(
      {Key? key, required this.senderUserId, required this.recieverUserId})
      : super(key: key);
  @override
  State<sendRequestButton> createState() => _sendRequestButtonState();
}

class _sendRequestButtonState extends State<sendRequestButton> {
  bool sent = false;
  @override
  Widget build(BuildContext context) {
    if (sent) {
      return FutureBuilder(
        future: sendFriendRequest(widget.senderUserId, widget.recieverUserId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return IconButton(
                icon: const Icon(Icons.error_outline_outlined),
                iconSize: 30,
                color: Colors.deepOrange,
                tooltip: 'An error has occurred!',
                onPressed: () {},
              );
            }
            return IconButton(
              icon: const Icon(Icons.done_outline_outlined),
              iconSize: 30,
              color: Colors.deepOrange,
              tooltip: 'Request Sent',
              onPressed: () {},
            );
          }
          return const CircularProgressIndicator();
        },
      );
    }
    return IconButton(
      icon: const Icon(Icons.add_box_outlined),
      iconSize: 30,
      color: Colors.deepOrange,
      tooltip: 'Send a friend request.',
      onPressed: () {
        setState(() {
          sent = true;
        });
      },
    );
  }

  Future sendFriendRequest(String senderUserId, String recieverUserId) async {
    await FirebaseFirestore.instance
        .collection('usersFriends')
        .doc(recieverUserId)
        .set({
      "requests": FieldValue.arrayUnion([senderUserId])
    });
  }
}

class friendRequestCard extends StatefulWidget {
  final String senderUserId;
  const friendRequestCard({Key? key, required this.senderUserId})
      : super(key: key);
  @override
  State<friendRequestCard> createState() => _friendRequestCardState();
}

class _friendRequestCardState extends State<friendRequestCard> {
  String currUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserObj.retrieveUserData(widget.senderUserId),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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

          UserObj user = snapshot.data!['user'];
          NetworkImage image = snapshot.data!['image'];
          return ExpansionTile(
            leading: CircleAvatar(foregroundImage: image),
            title: Text('Friend Request from ' + user.name),
            children: <Widget>[
              ListTile(
                title: Text(user.course + ' Year ' + user.year.toString()),
                subtitle: Text(user.bio),
                trailing: acceptRequestButton(
                    senderUserId: widget.senderUserId,
                    recieverUserId: currUserId),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class acceptRequestButton extends StatefulWidget {
  final String senderUserId;
  final String recieverUserId;
  const acceptRequestButton(
      {Key? key, required this.senderUserId, required this.recieverUserId})
      : super(key: key);
  @override
  State<acceptRequestButton> createState() => _acceptRequestButtonState();
}

class _acceptRequestButtonState extends State<acceptRequestButton> {
  bool accepted = false;
  @override
  Widget build(BuildContext context) {
    if (accepted) {
      return FutureBuilder(
        future: acceptFriendRequest(widget.senderUserId, widget.recieverUserId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return IconButton(
                icon: const Icon(Icons.error_outline_outlined),
                iconSize: 30,
                color: Colors.deepOrange,
                tooltip: 'An error has occurred!',
                onPressed: () {},
              );
            }
            return IconButton(
              icon: const Icon(Icons.done_outline_outlined),
              iconSize: 30,
              color: Colors.deepOrange,
              tooltip: 'Request Accepted',
              onPressed: () {},
            );
          }
          return const CircularProgressIndicator();
        },
      );
    }
    return IconButton(
      icon: const Icon(Icons.add_box_outlined),
      iconSize: 30,
      color: Colors.deepOrange,
      tooltip: 'Send a friend request.',
      onPressed: () {
        setState(() {
          accepted = true;
        });
      },
    );
  }

  Future acceptFriendRequest(String senderUserId, String recieverUserId) async {
    await FirebaseFirestore.instance
        .collection('usersFriends')
        .doc(recieverUserId)
        .set({
      "requests": FieldValue.arrayRemove([senderUserId])
    });
    await FirebaseFirestore.instance
        .collection('usersFriends')
        .doc(recieverUserId)
        .set({
      "friends": FieldValue.arrayUnion([senderUserId])
    });
    await FirebaseFirestore.instance
        .collection('usersFriends')
        .doc(senderUserId)
        .set({
      "friends": FieldValue.arrayUnion([recieverUserId])
    });
  }
}
