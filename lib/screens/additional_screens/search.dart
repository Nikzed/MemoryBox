import 'package:first_project_test/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}
class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 70);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(50),
          ),
        ),
        backgroundColor: Color(0xff8c84e2),
      ),
      body: SizedBox(
        height: 400,
        child: ClipPath(
          clipper: CustomShape(), // this is my own class which extendsCustomClipper
          child: Container(
            height: 150,
            color: Color(0xff8c84e2),
          ),
        ),
      ),
      // body: Align(
      //   alignment: Alignment.bottomRight,
      //   child: Padding(
      //     padding: EdgeInsets.only(bottom: 90),
      //     child: Container(
      //       height: 50,
      //       width: 150,
      //       decoration: BoxDecoration(
      //         color: Colors.greenAccent,
      //         borderRadius: BorderRadius.only(
      //           topLeft: Radius.circular(15),
      //         ),
      //       ),
      //       child: Align(
      //         alignment: Alignment.center,
      //         child: Text(
      //           '24.00 \$',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
