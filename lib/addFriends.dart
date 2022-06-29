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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: selectedPage(_selectedIndex), //New
      ),
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
      const Center(
        child: Text('Work in Progress'),
      ),
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
        builder: (BuildContext context, AsyncSnapshot<List<UserObj>> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('Something went wrong, oops!'),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            List<UserObj> usersList = snapshot.data!;
            return ListView.builder(
              itemCount: usersList.length,
              itemBuilder: (BuildContext context, int index) {
                UserObj user = usersList[index];

                return ListTile(
                  leading: FutureBuilder(
                      future: UserObj.retrieveUserImage(user.imgName),
                      builder: (BuildContext context,
                          AsyncSnapshot<ImageProvider> snapshot) {
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
                      }),
                  title: Text(user.name),
                  subtitle: Text('Course: ' +
                      user.course +
                      ' Year ' +
                      user.year.toString()),
                  onTap: () {},
                );
              },
            );
          }
          return loadingScreen(context);
        });
  }

  // Widget requestsPage(BuildContext context) {
  //   @override
  //   Widget build(BuildContext context) {

  //   }
  // }

  Stream<List<UserObj>> getUsersList() {
    Stream<List<UserObj>> usersList = FirebaseFirestore.instance
        .collection('usersInfo')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserObj.fromJson(doc.data())).toList());
    return usersList;
  }
}
