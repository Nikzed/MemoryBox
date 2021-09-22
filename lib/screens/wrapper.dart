import 'package:first_project_test/screens/authenticate/authenticate.dart';
import 'package:first_project_test/screens/home/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // return Home or Authenticate widget
    return Authenticate();
  }
}
