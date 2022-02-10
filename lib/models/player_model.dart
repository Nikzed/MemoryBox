import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/models/slider_model.dart';
import 'package:flutter/material.dart';

class PlayerModel extends StatefulWidget {
  const PlayerModel({Key? key}) : super(key: key);

  @override
  _PlayerModelState createState() => _PlayerModelState();
}

class _PlayerModelState extends State<PlayerModel> {
  bool isPlaying = true;
  double tempValue = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff8C84E2),
              Color(0xff6C689F),
            ],
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: InkResponse(
                onTap: () => print('hello!'),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: accentColor,
                      size: 35,
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                      print(isPlaying);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('hello'),
                SizedBox(
                  height: 20,
                  width: 240,
                  child: SliderTheme(

                    data: SliderThemeData(
                      trackHeight: 1,
                      trackShape: CustomTrackShape(),
                      disabledActiveTrackColor: Colors.blue,
                      disabledInactiveTrackColor: Colors.black12,
                      thumbShape: CustomSliderPlayer(thumbRadius: 5),
                    ),
                    child: Slider(
                      value: tempValue,
                      min: 0,
                      max: 4,
                      divisions: 4,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white,
                      onChanged: (value) async {
                        setState(() {
                          tempValue = value;
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('00:00'),
                    SizedBox(width: 90,),
                    Text('99:99'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
