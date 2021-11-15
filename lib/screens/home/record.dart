import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;

typedef Fn = void Function();

StreamSubscription? _recorderSubscription;
StreamSubscription? _mPlayerSubscription;

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> with TickerProviderStateMixin {
  final backgroundColor = 0xffF6F6F6;

  // FlutterSoundPlayer? _player = FlutterSoundPlayer();
  // FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  // bool _playerIsInited = false;
  // bool _recorderIsInited = false;
  // bool _playbackReady = false;
  // String? _path;
  // StreamSubscription? _recordingDataSubscription;
  // String _recorderText = '00:00:00';
  // String _playerText = '00:00:00';

  // -- Recorder --
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  Codec _codec = Codec.aacADTS;
  String _fileName = 'Recording_.aac';
  String _path = '/storage/emulated/0/SoundRecorder';
  bool _mRecorderIsInited = false;
  int pos = 0;
  double dbLevel = 0;

  // -- Player --
  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  int playerPos = 0;
  double? _duration;

  // -- NoiseListener --
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  int currentNoise = 0;
  List noisesList = List.generate(20, (index) => 0);

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
    super.initState();
    init().then((value) {
      setState(() {
        _mRecorderIsInited = true;
        _mPlayerIsInited = true;
      });
    });

    // added  for listener
    _noiseMeter = NoiseMeter(onErrorListener);

    startListener();
  }

  Future<void> init() async {
    // recorder init
    await openRecorder();
    await _mRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
    _recorderSubscription = _mRecorder.onProgress!.listen((event) {
      setState(() {
        pos = event.duration.inMilliseconds;
        // СТАНДАРТНЫЙ ПАКЕТ В КОТОРОМ ЕСТЬ ТЕКУЩАЯ ГРОМКОСТЬ
        if (event.decibels != null) {
          dbLevel = event.decibels as double;
        }
      });
    });

    // player init
    await _mPlayer.openAudioSession();
    await _mPlayer.setSubscriptionDuration(Duration(milliseconds: 50));
    _mPlayerSubscription = _mPlayer.onProgress!.listen((e) {
      setPos(e.position.inMilliseconds);
      setState(() {});
    });
  }

  Future<void> setPos(int d) async {
    if (d > _duration!) {
      d = _duration!.toInt();
    }
    setState(() {
      playerPos = d;
    });
  }

  Future<void> seek(double d) async {
    await _mPlayer.seekToPlayer(Duration(milliseconds: d.floor()));
    await setPos(d.floor());
  }

  Future<void> getDuration() async {
    var path = _path[_codec.index];
    var d = path != null ? await flutterSoundHelper.duration(path) : null;
    _duration = d != null ? d.inMilliseconds / 1000.0 : null;

    setState(() {});
  }

  void play(FlutterSoundPlayer? player) async {
    await player!.startPlayer(
      fromURI: ('$_path/$_fileName'),
        // fromDataBuffer: _boumData,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {});
        });
    setState(() {});
  }
  Future<void> stopPlayer(FlutterSoundPlayer player) async {
    await player.stopPlayer();
  }

  Future<void> openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Доступ к микрофону не получен!');
    }
    await _mRecorder.openAudioSession();

    _mRecorderIsInited = true;
  }

  void cancelRecorderSubscription() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }
  void cancelPlayerSubscriptions() {
    if (_mPlayerSubscription != null) {
      _mPlayerSubscription!.cancel();
      _mPlayerSubscription = null;
    }
  }
  // ----- LISTENER START -----

  void startListener() async {
    try {
      _noiseSubscription = _noiseMeter!.noiseStream.listen(onDataListener);
    } on Exception catch (exception) {
      print(exception);
    }
  }

  void onDataListener(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });

    /// Do someting with the noiseReading object
    noiseReading.meanDecibel == double.negativeInfinity
        ? currentNoise = 0
        : currentNoise = ((noiseReading.meanDecibel - 50) * 2).toInt();
    currentNoise < 0 ? currentNoise = 0 : null;
    for (int i = 0; i < 19; i++) {
      noisesList[i] = noisesList[i + 1];
    }
    noisesList.removeLast();
    noisesList.add(currentNoise);
    // print(noiseReading.toString());
  }

  void onErrorListener(Object error) {
    print(error.toString());
    _isRecording = false;
  }

  void stopRecorderListener() async {
    noisesList = List.generate(20, (index) => 0);
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  // ----- LISTENER END -----

  // ----- RECORDER START -----

  void record(FlutterSoundRecorder? recorder) async {
    await recorder!.startRecorder(codec: _codec, toFile: _fileName);
    setState(() {});
  }

  Future<void> stopRecorder(FlutterSoundRecorder recorder) async {
    await recorder.stopRecorder();
    // _boumData = await getAssetData('$_path/$_fileName');
    _writeFileToStorage();
  }

  void _createFile() async {
    File(_path + '/' + _fileName)
        .create(recursive: true)
        .then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      print(file.path);
    });
  }

  void _createDirectory() async {
    bool isDirectoryCreated = await Directory(_path).exists();
    if (!isDirectoryCreated) {
      Directory(_path).create()
      // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }
  }

  Future<bool> _hasAcceptedPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      await Permission.manageExternalStorage.request();

      return true;

      if (await Permission.storage.isGranted &&
          // access media location needed for android 10/Q
          await Permission.accessMediaLocation.isGranted &&
          // manage external storage needed for android 11/R
          await Permission.manageExternalStorage.isGranted) {
        return true;
      } else {
        return false;
      }
    }
    if (Platform.isIOS) {
      // if (await _requestPermission(Permission.photos)) {
      //   return true;
      // } else {
      //   return false;
      // }
      return true;
    } else {
      // not android or ios
      return false;
    }}

  void _writeFileToStorage() async {
    if (await _hasAcceptedPermissions()) {
      _createDirectory();
      _createFile();
    }
    else {
      print('НЕ ПРОШЛО!!!!!!!!');
    }
  }

  // ----- RECORDER END -----

  Fn? getRecorderFn(FlutterSoundRecorder? recorder) {
    if (!_mRecorderIsInited) {
      return null;
    }
    return recorder!.isStopped
        ? () {
            record(recorder);
          }
        : () {
            stopRecorder(recorder);
          };
  }

  Fn? getPlaybackFn(FlutterSoundPlayer? player) {
    if (!_mPlayerIsInited) {
      return null;
    }
    return player!.isStopped
        ? () {
      play(player);
    }
        : () {
      stopPlayer(player).then((value) => setState(() {}));
    };
  }

  @override
  void dispose() {
    stopRecorder(_mRecorder);
    cancelRecorderSubscription();
    _mRecorder.closeAudioSession();

    stopPlayer(_mPlayer);
    cancelPlayerSubscriptions();
    _mPlayer.closeAudioSession();


    _animationController.dispose();

    _noiseSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.55,
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
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            margin: EdgeInsets.all(10),
            color: Color(backgroundColor),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  InkWell(
                    // onTap: getRecorderFunction(),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 250),
                      child: Text('Отменить'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      'Запись',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomPaint(
                    // painter: ShapePainter(currentNoise),
                    painter: ShapePainter(noisesList),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isRecording) ...[
                        _getRecordAnimatedDot(),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                      Text('test'),
                      // Text(
                      //   '${_recorder!.isRecording || _player!.isStopped ? _recorderText : _playerText}',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        // shape:
                        ),
                    onPressed: null,
                    // onPressed: getPlaybackFunction(),
                    //color: Colors.white,
                    //disabledColor: Colors.grey,
                    child: Text('test'),
                    // child: Text(_player!.isPlaying ? 'Stop' : 'Play'),
                  ),
                  Container(
                    margin: const EdgeInsets.all(3),
                    padding: const EdgeInsets.all(3),
                    height: 140,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFFAF0E6),
                      border: Border.all(
                        color: Colors.indigo,
                        width: 3,
                      ),
                    ),
                    child: Column(children: [
                      Row(children: [
                        ElevatedButton(
                          onPressed: getRecorderFn(_mRecorder),
                          child:
                              Text(_mRecorder.isRecording ? 'Stop' : 'Record'),
                        ),
                        ElevatedButton(onPressed: getPlaybackFn(_mPlayer), child: Text('Play')),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                            'Pos: $pos  dbLevel: ${((dbLevel * 100.0).floor()) / 100}'),
                      ]),
                      Text('Subscription Duration:'),
                    ]),
                    //),
                    //],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
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
}

class ShapePainter extends CustomPainter {
  List maxPoints = [];

  ShapePainter(this.maxPoints);

  @override
  void paint(Canvas canvas, Size size) {
    // maxPoint <= 0 ? maxPoint = 0 : null;

    var paint = Paint()
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
