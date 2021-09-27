import 'package:first_project_test/model/user.dart' as custom;
import 'package:first_project_test/screens/authenticate/authenticate.dart';
import 'package:first_project_test/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<custom.User?>(context);
    print(user);

    // return Home or Authenticate widget
    return Authenticate();
  }
}
