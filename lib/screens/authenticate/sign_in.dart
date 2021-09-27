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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0.0, // убирает тень
        title: Text('Продолжить'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child: Text('Sign in anon'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.pink)
          ),
          onPressed: () async {

            dynamic result = await _auth.signInAnon();

            if (result == null){
              throw ErrorDescription('error signing in');
            }
            else {
              print('signed in');
              print(result);
              return result;
            }
          },
        ),
      ),
    );
  }
}
