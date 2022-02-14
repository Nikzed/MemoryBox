import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/controllers/wrapper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioForm extends StatefulWidget {
  final name;
  final duration;

  AudioForm({
    Key? key,
    this.name = 'Неизвестно',
    this.duration = 0,
  }) : super(key: key);

  @override
  State<AudioForm> createState() => _AudioFormState();
}

class _AudioFormState extends State<AudioForm> {
  bool isPlaying = false;
  final WrapperController f = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(
        side: BorderSide(
          color: Color(0xff3A3A5533),
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        height: 60,
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
                    color: Color(0xff8C84E2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Obx(
                      () => Icon(
                        f.playingSong == widget.name
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        // isPlaying
                        //     ? Icons.pause_rounded
                        //     : Icons.play_arrow_rounded,
                        color: backgroundColor,
                        size: 35,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                      // check
                      f.startPlayer(widget.name);
                      print(isPlaying);
                      // isn't updating
                      print('f.isPlaying.value: ${f.isPlaying.value}');
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
                Text(
                  widget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff3A3A5580).withOpacity(1),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '${widget.duration} минут',
                  style: TextStyle(
                    color: Color(0xff3A3A5580).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
