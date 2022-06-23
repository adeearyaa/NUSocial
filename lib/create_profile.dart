import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/homePage.dart';
import 'package:nus_social/signInPage.dart';
import 'package:nus_social/main.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'signInPage.dart';
import 'homePage.dart';

class CreateProfile extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your Profile'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Choose your Display Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              controller: courseController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Course',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              controller: yearController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Year of Study',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              controller: bioController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Write a short Bio about yourself',
              ),
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ElevatedButton(
              child: const Text('Save Changes'),
              onPressed: () {
                final name = nameController.text;
                final course = courseController.text;
                final int year = int.parse(yearController.text);
                final bio = bioController.text;

                createUserProfile(name, course, year, bio);

                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const WelcomePage()));
              },
            ),
          ),
        ],
      )),
    );
  }

  Future createUserProfile(
      String name, String course, int year, String bio) async {
    final userRef = FirebaseAuth.instance.currentUser;

    if (userRef != null) {
      final userID = userRef.uid;
      final userEmail = userRef.email;
      final docUser =
          FirebaseFirestore.instance.collection('usersInfo').doc(userID);

      final user = UserObj(
        id: userID,
        userName: userEmail.toString(),
        name: name,
        course: course,
        year: year,
        bio: bio,
      );

      await docUser.set(user.toJson());
    }
  }
}
