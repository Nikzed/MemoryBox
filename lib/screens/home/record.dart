import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/models/painter_model.dart';
import 'package:first_project_test/models/slider_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../models/slider_model.dart';

typedef Fn = void Function();

StreamSubscription? _recorderSubscription;
StreamSubscription? _playerSubscription;

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> with TickerProviderStateMixin {
  bool storagePermissionIsGranted = false;
  String _tempFileName = 'Recording_.aac';
  String? _fileName;
  String _directoryPath = '/storage/emulated/0/SoundRecorder';
  late String filePath;

  // -- Recorder --
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;

  bool get _isRecording => _recorder.isRecording;
  String _recorderText = '0:00:00';
  double _noiseInDb = 0;
  List _noisesList = List.generate(20, (index) => 0);

  // -- Player --
  FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool get _isPlaying => _player.isPlaying;
  bool playing = false;
  String _playerText = '00:00:00';
  double _maxDuration = 0.0;
  double _sliderPos = 0.0;
  Uint8List? _boumData;

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
  void initState() {
    print('1 - initR');
    _initRecorder();
    print('2 - initP');
    _initPlayer();
    print('3 - toggle');
    super.initState();
  }

  // ----- RECORDER START -----

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Recording permission required.');
    }
    await _recorder.openAudioSession();

    _isRecorderInitialized = true;
    print('_isRecorderInitialized $_isRecorderInitialized');
    await _toggleRecording();
  }

  Future _startRecorder() async {
    if (!_isRecorderInitialized) {
      return;
    }
    Directory directory = await getApplicationDocumentsDirectory();
    // Возможность инициализировать все записанные аудио
    // String filePath = directory.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.aac';
    // Временный файл
    String filePath = directory.path + '/' + 'temp' + '.aac';

    await _recorder.setSubscriptionDuration(Duration(milliseconds: 150));
    _recorderSubscription = await _recorder.onProgress!.listen((event) {
      setState(() {
        if (event.decibels != null) {
          _noiseInDb = event.decibels!.ceilToDouble();
        }
      });
      for (int i = 0; i < 19; i++) {
        _noisesList[i] = _noisesList[i + 1];
      }

      _noisesList.removeLast();
      _noisesList.add(_noiseInDb);
      print('noiseList => $_noisesList');

      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          event.duration.inMilliseconds,
          isUtc: true);
      String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

      _recorderText = txt.substring(0, 8);
    });
    await _recorder.startRecorder(
      // toFile: _tempFileName,
      toFile: filePath,
      codec: Codec.aacADTS,
    );
    print('recording to $filePath');
  }

  Future<void> _stopRecorder() async {
    if (!_isRecorderInitialized) {
      return;
    }
    await _recorder.stopRecorder();
    await cancelRecorderSubscriptions();
    setState(() {
      _noisesList = List.generate(20, (index) => 0);
    });
    //_writeFileToStorage();
  }

  Future<void> cancelRecorderSubscriptions() async {
    if (_recorderSubscription != null) {
      await _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  Future<void> _writeFileToStorage() async {
    await _getStoragePermission();
    await _createDirectory();
    await _createFile();
  }

  Future<void> _writeFileToFirebase() async {
    FirebaseFirestore.instance
        .collection('data')
        .add({'text': 'data added through an app'});
  }

  Future<void> _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        storagePermissionIsGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        storagePermissionIsGranted = false;
      });
    }
  }

  Future<void> _createDirectory() async {
    bool isDirectoryCreated = await Directory(_directoryPath).exists();
    if (!isDirectoryCreated) {
      Directory(_directoryPath).create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }
  }

  Future<void> _createFile() async {
    String _completeFileName = await _generateFileName();
    File(_directoryPath + '/' + _completeFileName)
        .create(recursive: true)
        .then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      print(file.path);
      filePath = file.path;
    });
  }

  Future<String> _generateFileName([int i = 1]) async {
    if (await File(_directoryPath + '/' + 'Запись №$i.aac').exists()) {
      return _generateFileName(i + 1);
    }
    return 'Запись №$i.aac';
  }

  Future _toggleRecording() async {
    if (_isRecording) {
      await _stopRecorder();
    } else {
      await _startRecorder();
    }
  }

  // ----- RECORDER END -----

  // ----- PLAYER START -----

  Future<void> _initPlayer() async {
    await _player.openAudioSession();

    await _player.setSubscriptionDuration(Duration(milliseconds: 150));
    await initializeDateFormatting();

    _playerSubscription = _player.onProgress!.listen((event) {
      _maxDuration = event.duration.inMilliseconds.toDouble();
      if (_maxDuration < 0) _maxDuration = 0.0;

      String txt = DateFormat('mm:ss:SS', 'en_GB').format(
        DateTime.fromMicrosecondsSinceEpoch(event.position.inMilliseconds,
            isUtc: true),
      );
      _playerText = txt.substring(0, 5);

      _sliderPos = event.position.inMicroseconds.toDouble();
    });

    _fileName = await _generateFileName();
  }

  Future startPlayer() async {
    try {
      String? audioFilePath = _tempFileName;
      Codec codec = Codec.aacADTS;
      if (_player.isPaused) {
        await _player.resumePlayer();
      } else {
        await _player.startPlayer(
            fromURI: audioFilePath,
            codec: codec,
            whenFinished: () {
              _player.logger.d('Player finished');
            });
      }
    } on Exception catch (err) {
      print('ERROR HAPPENED');
      _player.logger.e('error: $err');
    }

    String? audioFilePath = _tempFileName;
    Codec codec = Codec.aacADTS;

    await _player.startPlayer(
      fromURI: audioFilePath,
      codec: codec,
      whenFinished: () => null,
    );
  }

  // Future<void> seekToSec(int milliSec) async {
  //   if (_player.isPlaying) {
  //     await _player.seekToPlayer(Duration(milliseconds: milliSec));
  //   }
  //   _sliderPos = milliSec.toDouble();
  // }

  // Future<void> playback15Seconds() async {
  //   await _player.seekToPlayer(Duration(seconds: _sliderPosition.toInt() - 15));
  // }
  //
  // Future<void> playForward15Seconds() async {
  //   await _player.seekToPlayer(Duration(seconds: _sliderPosition.toInt() + 15));
  // }

  // Future<void> seekToPlayer(int milliSec) async {
  //   try {
  //     if (_player.isPlaying) {
  //       await _player.seekToPlayer(Duration(milliseconds: milliSec));
  //     }
  //   } on Exception catch (err) {
  //     _player.logger.e('error: $err');
  //   }
  //   _sliderPosition = milliSec.toDouble();
  // }

  Future stopPlayer() async {
    await _player.pausePlayer();
  }

  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
  }

  Future<void> togglePlayer() async {
    print('_isPlaying: $_isPlaying');
    if (!playing) {
      setState(() {
        playing = true;
      });
      await startPlayer();
    } else {
      setState(() {
        playing = false;
      });
      await stopPlayer();
    }
  }

  // ----- PLAYER END -----

  @override
  void dispose() {
    // recorder
    _recorder.closeAudioSession();
    _isRecorderInitialized = false;
    cancelRecorderSubscriptions();
    // player
    _player.closeAudioSession();
    cancelPlayerSubscriptions();

    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _getPageWidget();
  }

  Widget _getPageWidget() {
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
          padding: EdgeInsets.only(top: 100),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: ListView(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  margin: EdgeInsets.all(10),
                  color: backgroundColor,
                  child: _isRecorderInitialized
                      ? _isRecording
                          ? _getRecorderWidget()
                          : _getPlayerWidget()
                      : _getRecorderWidget(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget? _getRecorderWidget() {
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
              onTap: () => _toggleRecording(),
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
          painter: _ShapePainter(_noisesList),
        ),
        SizedBox(height: 125),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getRecordAnimatedDot(),
            Text('$_recorderText'),
          ],
        ),
        SizedBox(height: 50),
        _getStopButton(),
      ],
    );
  }

  Widget _getStopButton() {
    return Container(
      child: InkResponse(
        onTap: () => _toggleRecording(),
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
                onPressed: () => _onFileUploadButtonPressed(),
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
                onTap: () => _writeFileToStorage(),
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
          child: Text(
            _fileName!,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(height: 50),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 2,
            thumbShape: CustomSliderPlayer(thumbRadius: 5),
          ),
          child: Slider(
            activeColor: Color(0xff3A3A55),
            inactiveColor: Color(0xff3A3A55),
            value: _sliderPos,
            onChanged: (val) {
              _sliderPos = val;
              setState(() {});
            },
          ),
        ),
        SizedBox(height: 155),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              // onTap: () => playback15Seconds(),
              child: SvgPicture.asset('assets/play_backward.svg'),
            ),
            SizedBox(width: 50),
            _getPlayButton(),
            SizedBox(width: 50),
            InkWell(
              // onTap: () => playForward15Seconds(),
              child: SvgPicture.asset('assets/play_forward.svg'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _onFileUploadButtonPressed() async {
    // setState(() {
    //   _isUploading = true;
    // });
    try {
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      await firebaseStorage
          .ref('upload-voice-firebase')
          .child(filePath.substring(filePath.lastIndexOf('/'), filePath.length))
          .putFile(File(filePath));
      _onUploadComplete();
    } catch (error) {
      print('Error occured while uplaoding to Firebase ${error.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occured while uplaoding'),
        ),
      );
    } finally {
      // setState(() {
      //   _isUploading = false;
      // });
    }
  }

  Future<void> _onUploadComplete() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    await firebaseStorage.ref().child('upload-voice-firebase').list();
  }

  Widget _getPlayButton() {
    return Container(
      child: InkResponse(
        onTap: () => togglePlayer(),
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
            playing ? Icons.ten_k : Icons.play_arrow_rounded,
            //? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: backgroundColor,
            size: 48,
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
