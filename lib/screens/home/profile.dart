import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/cupertino.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.55,
            width: double.infinity,
            child: CustomPaint(
              painter: CirclePainter(),
            ),
          ),
          
        ],
      ),
    );
  }
}
