import 'package:flutter/material.dart';
import 'package:flutter/src/material/color_scheme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'NUSocial';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title,style: TextStyle(fontSize: 30),),
          backgroundColor: Colors.deepOrange,),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'WELCOME!',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height:50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )
            ),
            Row(
              children: <Widget>[
                const Text('Not a member?'),
                TextButton(
                  child: const Text(
                    'Sign up!',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpScreen()));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
}

class SignUpScreen extends StatefulWidget{
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
            title: const Text('SIGN UP', style: TextStyle(fontSize: 30),),
            backgroundColor: Colors.deepOrange,),
          body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp()));
                        }, icon: Icon(
                            Icons.arrow_back
                        )
                        )
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
                        height:50,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: ElevatedButton(
                          child: const Text('Confirm account'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WelcomePage()));
                          },
                        )
                    ),
                  ]))
      ),
    );
  }
}

class WelcomePage extends StatefulWidget{
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SIGN UP',
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                'WELCOME BACK USERNAME', style: TextStyle(fontSize: 20),),
              backgroundColor: Colors.deepOrange,),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(15,80,15,15),
                child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(15),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      ElevatedButton.icon(onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MyApp()));
                      }, icon: Icon(
                          Icons.person_add, size:50
                      ),
                        label: Text("Add Friends"),
                          style: ElevatedButton.styleFrom(
                            primary : Colors.lightBlue,
                          )
                      ),
                      ElevatedButton.icon(onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MyApp()));
                      }, icon: Icon(
                          Icons.emoji_events_outlined, size:50
                      ),
                        label: Text("Games"),
                          style: ElevatedButton.styleFrom(
                            primary : Colors.lightBlue,
                          )
                      ),
                      ElevatedButton.icon(onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MyApp()));
                      }, icon: Icon(
                          Icons.chat_bubble_outline_outlined, size:50
                      ),
                        label: Text("Chat"),
                          style: ElevatedButton.styleFrom(
                            primary : Colors.lightBlue,
                          )
                      ),
                      ElevatedButton.icon(onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => MyApp()));
                      }, icon: Icon(
                          Icons.people_alt, size:50
                      ),
                        label: Text("My Friends"),
                        style: ElevatedButton.styleFrom(
                          primary : Colors.lightBlue,
                        )
                      )
                    ]

                )
            )
        )
    );
  }
}




