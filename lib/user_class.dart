import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

//User class to store user info. Methods to convert to json and vice versa to
//store on firebase collections are provided.
//Asynchronous methods to retrieve user object and profile picture as a map are
//also provided.

class UserObj {
  String id;
  String userName;
  String name;
  String course;
  int year;
  String bio;
  String imgName;
  static const ImageProvider emptyAvatarImage =
      AssetImage('assets/images/avatar_blank.jpg');

  UserObj({
    this.id = '',
    required this.userName,
    required this.name,
    required this.course,
    required this.year,
    required this.bio,
    required this.imgName,
  });

  //Converts user object to json file to store in firebase collections.
  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'name': name,
        'course': course,
        'year': year,
        'bio': bio,
        'imgName': imgName,
      };
  //Converts json from firebase collections to user object.
  static UserObj fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserObj.nullUser();
    }

    return UserObj(
      id: json['id'],
      userName: json['userName'],
      name: json['name'],
      course: json['course'],
      year: json['year'],
      bio: json['bio'],
      imgName: json['imgName'],
    );
  }

  //Empty user object.
  static UserObj nullUser() => UserObj(
      id: '',
      userName: '',
      name: '',
      course: '-',
      year: 0,
      bio: '',
      imgName: '');

  //Empty map with an empty user object and a default avatar picture.
  static Map<String, dynamic> emptyMap() => {
        'user': UserObj.nullUser(),
        'image': UserObj.emptyAvatarImage,
      };

  //Retrives user object and profile picture asynchronously and stores it in a map.
  static Future<Map<String, dynamic>> retrieveUserData(String userId) async {
    UserObj user = await FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(userId)
        .get()
        .then((mapSnapshot) => UserObj.fromJson(mapSnapshot.data()));
    String imgName = user.imgName;
    try {
      final imgRef =
          FirebaseStorage.instance.ref().child('profileImages/$imgName');
      String? imgUrl = await imgRef.getDownloadURL();
      return {'user': user, 'image': NetworkImage(imgUrl)};
    } catch (e) {
      print(e);
      return {'user': user, 'image': emptyAvatarImage};
    }
  }

  //Retrives user profile image only using the image name.
  static Future<ImageProvider> retrieveUserImage(String imgName) async {
    //imgName is placeholder blank.
    if (imgName == '-') {
      return emptyAvatarImage;
    }

    final imgRef =
        FirebaseStorage.instance.ref().child('profileImages/$imgName');
    try {
      String imgUrl = await imgRef.getDownloadURL();
      return NetworkImage(imgUrl);
    } catch (e) {
      print(imgName + e.toString());
      return emptyAvatarImage;
    }
  }

  //Retrives user friends document on firestore.
  static Future<Map<String, dynamic>> retrieveUserFriends(String userId) async {
    final friendsDoc = await FirebaseFirestore.instance
        .collection('usersFriends')
        .doc(userId)
        .get();

    if (friendsDoc.data() == null) {
      return {};
    }
    return friendsDoc.data()!;
  }
}
