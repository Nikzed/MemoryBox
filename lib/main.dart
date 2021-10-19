import 'package:first_project_test/model/user_model.dart';
import 'package:first_project_test/screens/wrapper.dart';
import 'package:first_project_test/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';


const bool USE_EMULATOR = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_EMULATOR){
    _connectToFirebaseEmulator();
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white.withOpacity(0),
  ));
  runApp(MyApp());
}

Future _connectToFirebaseEmulator() async {
  final fireStorePort = "8090";
  final authPort = 9099;
  final localHost = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  FirebaseFirestore.instance.settings = Settings(
      host: "$localHost:$fireStorePort",
      sslEnabled: false,
      persistenceEnabled: false);

  await FirebaseAuth.instance.useAuthEmulator(localHost, authPort); //.useEmulator("http://$localHost:$authPort");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider - check
    return StreamBuilder<UserModel>(
      stream: null,
      builder: (context, snapshot) {
        return StreamProvider<UserModel?>.value(
          value: AuthService().user,
          initialData: null,
          child: MaterialApp(
            home: Wrapper(),
          ),
        );
      }
    );
  }
}

