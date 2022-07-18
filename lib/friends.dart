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

import 'package:nus_social/add_friends.dart';
import 'package:nus_social/authentication.dart';

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
import "package:nus_social/searchscreen.dart";

class FriendsPage extends StatelessWidget {
  String currUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
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
                      onPressed: () {},
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
}
