import 'package:first_project_test/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top:200),
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
            child: SizedBox(
              height: 60,
              child: TextField(
                cursorColor: Colors.black45,
                textAlign: TextAlign.center,
                enabled: true,
                controller: controller,
                keyboardType: TextInputType.phone,
                style:
                    Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 10),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
