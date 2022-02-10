import 'dart:io';
import 'dart:math';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/controllers/record_controller.dart';
import 'package:first_project_test/models/painter_model.dart';
import 'package:first_project_test/models/slider_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../models/slider_model.dart';

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

// TickerProviderStateMixin для работы с анимацией
class _RecordState extends State<Record> with TickerProviderStateMixin {
  RecordController _controller = Get.put(
    RecordController(),
  );

  // -- recording animation --
  final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
    ),
    end: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _animationController.dispose();
    Get.delete<RecordController>();
    print('trying to delete...');
    File('/storage/emulated/0/SoundRecorder/temp.aac').delete();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 350,
          width: double.infinity,
          child: CustomPaint(
            painter: CirclePainter(),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 40, left: 5),
            child: IconButton(
              color: Colors.white,
              iconSize: 28,
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 150),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              margin: EdgeInsets.all(10),
              color: backgroundColor,
              child: Obx(
                () => ListView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: EdgeInsets.zero,
                  children: [
                    if (_controller.isRecorderInitialized.value)
                      if (_controller.state == RecordState.RECORDING)
                        _getRecorderWidget()
                      else
                        _getPlayerWidget()
                    else
                      _getRecorderWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getRecorderWidget() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              right: 40,
            ),
            child: InkWell(
              onTap: () {
                _controller.stopRecorder();
                _controller.startRecorder();
              },
              child: Text('Отменить'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 50),
          child: Text(
            'Запись',
            style: TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(height: 150),
        CustomPaint(
          painter: _ShapePainter(_controller.noisesList),
        ),
        SizedBox(height: 125),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getRecordAnimatedDot(),
            Obx(
              () => Text('${_controller.recorderText.value}'),
            ),
          ],
        ),
        SizedBox(height: 50),
        _getStopButton(),
        SizedBox(height: 80),
      ],
    );
  }

  Widget _getStopButton() {
    return Container(
      child: InkResponse(
        onTap: () {
          _controller.toggleRecording();
          _controller.state.value = RecordState.PLAYING;
        },
        // _isRecording ? getRecorderFn(_mRecorder) : getPlaybackFn(_mPlayer),
        //getRecorderFn(_mRecorder),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Color(0xffF1B488),
            shape: BoxShape.circle,
          ),
          child: Icon(
            // _isRecording ? Icons.pause_rounded : Icons.play_arrow_rounded,
            Icons.pause_rounded,
            color: backgroundColor,
            size: 48,
          ),
        ),
      ),
    );
  }

  Widget _getRecordAnimatedDot() {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: DecoratedBoxTransition(
        decoration: decorationTween.animate(_animationController),
        child: Container(
          height: 10,
          width: 10,
        ),
      ),
    );
  }

  Widget _getPlayerWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => _controller.onFileUploadButtonPressed(),
                icon: SvgPicture.asset('assets/share.svg'),
              ),
              SizedBox(width: 20),
              IconButton(
                onPressed: null,
                icon: SvgPicture.asset('assets/paper_download.svg'),
              ),
              SizedBox(width: 20),
              IconButton(
                onPressed: null,
                icon: SvgPicture.asset('assets/delete.svg'),
              ),
              SizedBox(width: 75),
              InkWell(
                onTap: () => _controller.writeFileToStorage(),
                // onTap: () => _writeFileToFirebase(),
                // onTap: () => _onFileUploadButtonPressed(),
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
        SizedBox(height: 110),
        Align(
          alignment: Alignment.center,
          child: Obx(
            () => Text(
              // 'hello',
              // _controller.fileName.!value,
              _controller.fileName.value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(height: 50),
        SizedBox(
          height: 30,
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              thumbShape: CustomSliderPlayer(thumbRadius: 5),
            ),
            child: Slider(
              value: min(
                _controller.sliderPos.value,
                _controller.maxDuration.value,
              ),
              min: 0.0,
              max: _controller.maxDuration.value,
              activeColor: Color(0xff3A3A55),
              inactiveColor: Color(0xff3A3A55),
              onChanged: (value) async {
                await _controller.seekToPlayer(value.toInt());
              },
              divisions: _controller.maxDuration.value == 0.0
                  ? 1
                  : _controller.maxDuration.value.toInt(),
            ),
          ),
        ),
        Container(
          height: 30.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_controller.playerCurrentText.value),
                    Text(_controller.playerMaxText.value),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 140),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _controller.playback15Seconds(),
              child: SvgPicture.asset('assets/play_backward.svg'),
            ),
            SizedBox(width: 50),
            _getPlayButton(),
            SizedBox(width: 50),
            InkWell(
              onTap: () => _controller.playForward15Seconds(),
              child: SvgPicture.asset('assets/play_forward.svg'),
            ),
          ],
        ),
        SizedBox(height: 87),
      ],
    );
  }

  Widget _getPlayButton() {
    return Container(
      child: InkResponse(
        onTap: () => _controller.togglePlayer(),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Color(0xffF1B488),
            shape: BoxShape.circle,
          ),
          child: Obx(
            () => Icon(
              _controller.isPlaying.value
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              //? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: backgroundColor,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  List maxPoints = [];

  _ShapePainter(this.maxPoints);

  @override
  void paint(Canvas canvas, Size size) {
    // maxPoint <= 0 ? maxPoint = 0 : null;

    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 20; i++) {
      Offset startPoint = Offset(size.width / 2 + i * 10 - 90, size.height / 2);
      Offset endPoint =
          Offset(size.width / 2 + i * 10 - 90, size.height / 2 + maxPoints[i]);

      canvas.drawLine(startPoint, endPoint, paint);
      canvas.drawLine(startPoint, endPoint.scale(1, -1), paint);
    }
    canvas.drawLine(Offset(size.width / 2 - 90, size.height / 2),
        Offset(size.width / 2 + 100, size.height / 2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
