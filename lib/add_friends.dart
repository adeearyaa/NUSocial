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

import 'package:nus_social/add_friends.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/chats.dart';
import 'package:nus_social/create_profile.dart';
import 'package:nus_social/friends.dart';
import 'package:nus_social/games.dart';
import 'package:nus_social/home_page.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/sign_in_page.dart';
import 'package:nus_social/sign_up.dart';
import 'package:nus_social/user_class.dart';

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
              print('1');
              return Container(
                child: const Text('Something went wrong, oops! Error 1'),
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
                      child: const Text('Something went wrong, oops! Error 2'),
                    );
                  }
                  if (friendsSnapshot.hasError) {
                    return Container(
                      child: Text(friendsSnapshot.error.toString()),
                    );
                  }
                  List<dynamic>? rawList = friendsSnapshot.data!['friends'];
                  if (rawList != null) {
                    List<String>? friendsList = List<String>.from(rawList);
                    usersList
                        .removeWhere((user) => friendsList.contains(user.id));
                  }
                  return SearchBodyList(usersList: usersList);
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
              child: const Text('Something went wrong, oops! Error 3'),
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
                return FriendRequestCard(senderUserId: userId);
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

class SearchBodyList extends StatefulWidget {
  final List<UserObj> usersList;
  const SearchBodyList({Key? key, required this.usersList}) : super(key: key);
  @override
  State<SearchBodyList> createState() => _SearchBodyListState();
}

class _SearchBodyListState extends State<SearchBodyList> {
  String currUserId = FirebaseAuth.instance.currentUser!.uid;
  List<UserObj> filteredList = [];
  late TextEditingController query;

  @override
  void initState() {
    filteredList = widget.usersList;
    super.initState();
    query = TextEditingController()
      ..addListener(() {
        runListFilter(query.text);
      });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: TextField(
                  controller: query,
                  decoration: const InputDecoration(
                      labelText: 'Search by name',
                      suffixIcon: Icon(Icons.search)),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  query.clear();
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredList.length,
            itemBuilder: (BuildContext context, int index) {
              UserObj user = filteredList[index];

              return ExpansionTile(
                leading: displayUserProfilePicture(context, user.imgName),
                title: Text(user.name),
                children: <Widget>[
                  ListTile(
                      title:
                          Text(user.course + ' Year ' + user.year.toString()),
                      subtitle: Text(user.bio),
                      trailing: SendRequestButton(
                          senderUserId: currUserId, recieverUserId: user.id)),
                ],
              );
            },
          ),
        ],
      ),
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

class SendRequestButton extends StatefulWidget {
  final String senderUserId;
  final String recieverUserId;
  const SendRequestButton(
      {Key? key, required this.senderUserId, required this.recieverUserId})
      : super(key: key);
  @override
  State<SendRequestButton> createState() => _SendRequestButtonState();
}

class _SendRequestButtonState extends State<SendRequestButton> {
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

class FriendRequestCard extends StatefulWidget {
  final String senderUserId;
  const FriendRequestCard({Key? key, required this.senderUserId})
      : super(key: key);
  @override
  State<FriendRequestCard> createState() => _FriendRequestCardState();
}

class _FriendRequestCardState extends State<FriendRequestCard> {
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
              child: const Text('Something went wrong, oops! Error 4'),
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
                trailing: AcceptRequestButton(
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

class AcceptRequestButton extends StatefulWidget {
  final String senderUserId;
  final String recieverUserId;
  const AcceptRequestButton(
      {Key? key, required this.senderUserId, required this.recieverUserId})
      : super(key: key);
  @override
  State<AcceptRequestButton> createState() => _AcceptRequestButtonState();
}

class _AcceptRequestButtonState extends State<AcceptRequestButton> {
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
