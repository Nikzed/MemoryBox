import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/controllers/record_controller.dart';
import 'package:first_project_test/screens/authenticate/sign_in.dart';
import 'package:first_project_test/screens/home/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization.then(
    (value) => {
      Get.put(
        AuthController(),
      ),
    },
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MemoryBox',
      theme: ThemeData(fontFamily: 'TTNorms'),
      debugShowCheckedModeBanner: false,
      home: LinearProgressIndicator(
        backgroundColor: backgroundColor,
        color: Colors.white,
      ),
    );
  }
}