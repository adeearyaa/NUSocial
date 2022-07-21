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
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/chatroom.dart';
import 'package:nus_social/forget_password.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:email_validator/email_validator.dart';

import 'package:nus_social/add_friends.dart';
import 'package:nus_social/authentication.dart';

import 'package:nus_social/create_profile.dart';
import 'package:nus_social/friends.dart';

import 'package:nus_social/home_page.dart';
import 'package:nus_social/main.dart';
import 'package:nus_social/profile.dart';
import 'package:nus_social/settings.dart';
import 'package:nus_social/sign_in_page.dart';
import 'package:nus_social/sign_up.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          ListTile(
            leading: const Icon(
              Icons.email_outlined,
              color: Colors.deepOrange,
            ),
            title: const Text('Change E-Mail'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangeEmailPage()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.key_outlined,
              color: Colors.deepOrange,
            ),
            title: const Text('Change password'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChangePassPage()));
            },
          ),
        ]),
      ),
    );
  }
}

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({Key? key}) : super(key: key);

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  TextEditingController currEmail = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController newEmail = TextEditingController();
  bool changed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changing your E-Mail'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            controller: currEmail,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your current E-Mail address',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid E-Mail address'
                    : null,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            controller: pass,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your password',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (pass) => pass!.length < 6
                ? 'Password needs to be at least 6 characters long'
                : null,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            controller: newEmail,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your new E-Mail address',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid E-Mail address'
                    : null,
          ),
        ),
        const SizedBox(height: 20),
        saveEmailButton(context),
      ]),
    );
  }

  Widget saveEmailButton(BuildContext context) {
    if (changed) {
      return FutureBuilder(
          future: changeEmail(
              currEmail.text.trim(), pass.text.trim(), newEmail.text.trim()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: ElevatedButton(
                    child: const Text('An error has occured!'),
                    onPressed: () {
                      setState(() {
                        changed = false;
                      });
                    },
                  ),
                );
              } else if (snapshot.data == 1) {
                return Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Credentials do not match!'),
                    onPressed: () {
                      setState(() {
                        changed = false;
                      });
                    },
                  ),
                );
              }
              return Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: ElevatedButton(
                  child: const Text('Changes Saved'),
                  onPressed: () {},
                ),
              );
            }
            return const CircularProgressIndicator();
          });
    }
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: ElevatedButton(
        child: const Text('Save Changes'),
        onPressed: () {
          setState(() {
            changed = true;
          });
        },
      ),
    );
  }

  Future<int> changeEmail(
      String currEmail, String pass, String newEmail) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: currEmail, password: pass);
    try {
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      return 1;
    }
    await user.updateEmail(newEmail);
    await FirebaseFirestore.instance
        .collection('usersInfo')
        .doc(user.uid)
        .update({'userName': newEmail});
    return 0;
  }
}

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({Key? key}) : super(key: key);

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  TextEditingController email = TextEditingController();
  TextEditingController currPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  bool changed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Changing your Password'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            controller: email,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your new E-Mail address',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid E-Mail address'
                    : null,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            controller: currPass,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your current password',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (pass) => pass!.length < 6
                ? 'Password needs to be at least 6 characters long'
                : null,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            controller: newPass,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your new password',
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (pass) => pass!.length < 6
                ? 'Password needs to be at least 6 characters long'
                : null,
          ),
        ),
        const SizedBox(height: 20),
        savePassButton(context),
      ]),
    );
  }

  Widget savePassButton(BuildContext context) {
    if (changed) {
      return FutureBuilder(
          future: changePass(
              email.text.trim(), currPass.text.trim(), newPass.text.trim()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: ElevatedButton(
                    child: const Text('An error has occured!'),
                    onPressed: () {
                      setState(() {
                        changed = false;
                      });
                    },
                  ),
                );
              } else if (snapshot.data == 1) {
                return Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Credentials do not match!'),
                    onPressed: () {
                      setState(() {
                        changed = false;
                      });
                    },
                  ),
                );
              }
              return Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: ElevatedButton(
                  child: const Text('Changes Saved'),
                  onPressed: () {},
                ),
              );
            }
            return const CircularProgressIndicator();
          });
    }
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: ElevatedButton(
        child: const Text('Save Changes'),
        onPressed: () {
          setState(() {
            changed = true;
          });
        },
      ),
    );
  }

  Future<int> changePass(String email, String currPass, String newpass) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: currPass);
    try {
      await user.reauthenticateWithCredential(credential);
    } catch (e) {
      return 1;
    }
    await user.updatePassword(newpass);
    return 0;
  }
}
