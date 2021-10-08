import 'package:first_project_test/model/painter_model.dart';
import 'package:first_project_test/services/auth_service.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Container(
            width: 500,
            height: 400,
            child: CustomPaint(
              painter: CirclePainter(),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 60, top: 157, right: 59),
            width: 295,
            height: 67,
            child: Stack(
              children: [
                Text('MemoryBox',
                  style: TextStyle(color: Colors.white, fontSize: 48),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text('Твой голос всегда рядом',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 350.0),
            child: Column(
              children: [
                Text('data'),
                Text('sadadgood')
              ],
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 500.0),
            child: ElevatedButton(
              child: Text('Sign in anon'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.pink)),
              onPressed: () async {
                dynamic result = await _auth.signInAnon();

                if (result == null) {
                  print('error signing in');
                } else {
                  print('signed in');
                  return result.uid;
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}