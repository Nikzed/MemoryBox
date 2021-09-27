import 'package:first_project_test/model/user.dart' as custom;
import 'package:first_project_test/screens/wrapper.dart';
import 'package:first_project_test/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<custom.User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}