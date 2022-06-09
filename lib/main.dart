


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










