import 'package:first_project_test/model/user_model.dart';
import 'package:first_project_test/screens/authenticate/authenticate.dart';
import 'package:first_project_test/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// для отслеживания состояний
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    // return Home or Authenticate widget
    if(user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}
