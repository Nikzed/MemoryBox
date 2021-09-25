import 'package:firebase_core/firebase_core.dart';
import 'package:first_project_test/screens/wrapper.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  print('check changes');
  print('   changes another changes   changes    ');
  print(' changes another another another changes changes changes');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }
}