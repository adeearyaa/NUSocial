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

import 'package:nus_social/authentication.dart';
import 'package:nus_social/homePage.dart';
import 'package:nus_social/signInPage.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'authentication.dart';
import 'signInPage.dart';
import 'homePage.dart';

class CreateProfileWidget extends StatefulWidget {
  const CreateProfileWidget({Key? key}) : super(key: key);

  @override
  State<CreateProfileWidget> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfileWidget> {
  PlatformFile? pickedImg;
  String imgName = 'avatar_blank.jpg';

  TextEditingController nameController = TextEditingController();
  TextEditingController courseController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserObj.retrieveUserData(),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasError) {
            return profileCreationWidget(context, UserObj.emptyMap());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              !snapshot.hasData) {
            return profileCreationWidget(context, UserObj.emptyMap());
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return profileCreationWidget(context, snapshot.data!);
          }

          return loadingScreen(context);
        });
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
        imgName: imgName,
      );

      await docUser.set(user.toJson());
      uploadImg();
    }
  }

  Future selectImg() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile imgFile = result.files.first;

      setState(() {
        pickedImg = imgFile;
        imgName = imgFile.name;
      });
    }
  }

  Future uploadImg() async {
    PlatformFile? img = pickedImg;

    if (img != null) {
      String? imgPath = img.path;
      if (imgPath != null) {
        io.File image = io.File(imgPath);
        await FirebaseStorage.instance
            .ref('profileImages/$imgName')
            .putFile(image);
      }
    }
  }

  Widget profileCreationWidget(BuildContext context, Map<String, dynamic> map) {
    UserObj user = map['user'];

    nameController.text = user.name;
    courseController.text = user.course;
    yearController.text = user.year.toString();
    bioController.text = user.bio;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your Profile'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          profileImgPreview(context, map),
          Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: ElevatedButton(
              child: const Text('Upload Image'),
              onPressed: () {
                selectImg();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Choose your Display Name',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: courseController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Course',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
              controller: yearController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Year of Study',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextFormField(
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

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
          ),
        ],
      )),
    );
  }

  Widget profileImgPreview(BuildContext context, Map<String, dynamic> map) {
    if (pickedImg == null) {
      return CircleAvatar(
        foregroundImage: map['image'],
        radius: 100,
      );
    }

    return CircleAvatar(
      foregroundImage: FileImage(io.File(pickedImg!.path!)),
      radius: 100,
    );
  }
}
