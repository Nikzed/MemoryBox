import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_project_test/controllers/auth_controller.dart';
import 'package:first_project_test/controllers/record_controller.dart';
import 'package:get/get.dart';

AuthController authController = AuthController.instance;
final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
Color backgroundColor = Color(0xffF6F6F6);
Color accentColor = Color(0xff8c84e2);