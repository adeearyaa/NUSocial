


import 'package:flutter/material.dart';
import 'package:flutter/src/material/color_scheme.dart';
import 'package:nus_social/authentication.dart';
import 'package:nus_social/homePage.dart';
import 'package:nus_social/signInPage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';
import 'signInPage.dart';
import 'homePage.dart';




Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const _title = 'NUSocial';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers
    : [
      Provider <AuthenticationService>(
        create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null
        )
          ,
    ],
    child:MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            _title,
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: const AuthenticationWrapper(),
      ),
    )
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key? key,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    
    if (firebaseUser != null) {
       return WelcomePage();
    }

    return MyStatefulWidget();
  }
}



class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController newid = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  TextEditingController secondpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGN UP',
      home: Scaffold(
          appBar: AppBar(
            title: const Text(
              'SIGN UP',
              style: TextStyle(fontSize: 30),
            ),
            backgroundColor: Colors.deepOrange,
          ),
          body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => MyApp()));
                        },
                        icon: Icon(Icons.arrow_back))
                  ],
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'NEW ACCOUNT',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: newid,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Choose a new username',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextField(
                    obscureText: true,
                    controller: newpassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New Password',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: TextField(
                    obscureText: true,
                    controller: secondpassword,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Confirm account'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WelcomePage()));
                      },
                    )),
              ]))),
    );
  }
}






