import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

const int sampleRate = 44000;

typedef _Fn = void Function();

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  final backgroundColor = 0xffF6F6F6;
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _playerIsInited = false;
  bool _recorderIsInited = false;
  bool _playbackReady = false;
  String? _path;
  StreamSubscription? _recordingDataSubscription;
  String _recorderText = '00:00:00';
  String _playerText = '00:00:00';

  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  int currentNoise = 0;

  // List noisesList = [0,0,0,0,0,0,0,0,0,0];
  List noisesList = List.generate(20, (index) => 0);

  @override
  void initState() {
    super.initState();

    // added  for listener
    _noiseMeter = NoiseMeter(onErrorListener);

    startListener();

    // openAudioSession возвращает Future
    // Не открывать FlutterSoundPlayer или FlutterSoundRecorder до завершения Future метода
    _player!.openAudioSession().then((value) => {
          setState(() {
            _playerIsInited = true;
          }),
        });
    _openRecorder().then((value) => record());
  }

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
    for (int i=0; i<19; i++){
      noisesList[i] = noisesList[i+1];
    }
    noisesList.removeLast();
    noisesList.add(currentNoise);
    // print(noiseReading.toString());
    // noiseReading.meanDecibel = 5;
    // print(noiseReading.meanDecibel);
  }

  void onErrorListener(Object error) {
    print(error.toString());
    _isRecording = false;
  }

  void stopRecorderListener() async {
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

  @override
  void dispose() {
    _noiseSubscription?.cancel();

    stopPlayer();
    _player!.closeAudioSession();
    _player = null;

    stopRecorder();
    _recorder!.closeAudioSession();
    _recorder = null;
    super.dispose();
  }

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder!.openAudioSession();
    await _recorder!.setSubscriptionDuration(Duration(milliseconds: 100));
    await initializeDateFormatting();
    setState(() {
      _recorderIsInited = true;
    });
  }

  Future<IOSink> createFile() async {
    Directory tempDir = await getTemporaryDirectory();
    _path = '${tempDir.path}/temp.pcm';
    File outputFile = File(_path!);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }

  // Методы для работы с аудио
  Future<void> record() async {
    assert(_recorderIsInited && _player!.isStopped);
    IOSink sink = await createFile();
    StreamController<Food> recordingDataController = StreamController<Food>();
    _recordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        sink.add(buffer.data!);
      }
    });
    await _recorder!.startRecorder(
      // скорее всего придется поменять со стрима на файл
      toStream: recordingDataController.sink,
      // и попробовать с другим кодеком
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: sampleRate,
    );
    // можно сделать локальной переменной
    // StreamSubscription _recorderSubscription =
    _recorder!.onProgress!.listen((event) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          event.duration.inMilliseconds,
          isUtc: true);
      String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
      // TODO вызывает ли ошибку при dispose
      setState(() {
        _recorderText = txt.substring(0, 8);
      });
    });

    setState(() {});
  }

  Future<void> stopRecorder() async {
    await _recorder!.stopRecorder();
    if (_recordingDataSubscription != null) {
      await _recordingDataSubscription!.cancel();
      _recordingDataSubscription = null;
    }
    _playbackReady = true;
  }

  _Fn? getRecorderFunction() {
    if (!_recorderIsInited || !_player!.isStopped) {
      return null;
    }
    return _recorder!.isStopped
        ? record
        : () {
            stopRecorder().then((value) => setState(() {}));
          };
  }

  void play() async {
    assert(_playerIsInited &&
        _playbackReady &&
        _recorder!.isStopped &&
        _player!.isStopped);
    await _player!.startPlayer(
      fromURI: _path,
      sampleRate: sampleRate,
      codec: Codec.pcm16,
      numChannels: 1,
      whenFinished: () {
        setState(() {});
      },
    );
    _player!.setSubscriptionDuration(Duration(milliseconds: 100));
    await initializeDateFormatting();

    // переменная (можно реализовать на уровне класса)
    // StreamSubscription _playerSubscription =
    // можно реализовать слайдер через _addListeners() -> https://github.com/Canardoux/flutter_sound/blob/master/flutter_sound/example/lib/demo/demo.dart
    _player!.onProgress!.listen((event) {
      var date = DateTime.fromMillisecondsSinceEpoch(
          event.position.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
      setState(() {
        _playerText = txt.substring(0, 8);
      });
    });

    setState(() {});
  }

  Future<void> stopPlayer() async {
    await _player!.stopPlayer();
  }

  _Fn? getPlaybackFunction() {
    if (!_playerIsInited || !_playbackReady || !_recorder!.isStopped) {
      return null;
    }

    return _player!.isStopped
        ? play
        : () {
            stopPlayer().then((value) => setState(() {}));
          };
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
                    onTap: getRecorderFunction(),
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
                  Text('noise is : $currentNoise'),
                  SizedBox(height: 60),
                  CustomPaint(
                    // painter: ShapePainter(currentNoise),
                    painter: ShapePainter(noisesList),
                  ),
                  SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: getPlaybackFunction(),
                    //color: Colors.white,
                    //disabledColor: Colors.grey,
                    child: Text(_player!.isPlaying ? 'Stop' : 'Play'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: Text(
                        '${_recorder!.isRecording || _player!.isStopped ? _recorderText : _playerText}'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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

    for(int i=0; i<20; i++){
      Offset startPoint = Offset(size.width / 2 + i*10 - 100, size.height / 2);
      Offset endPoint = Offset(size.width / 2 + i*10 - 100, size.height / 2 + maxPoints[i]);

      canvas.drawLine(startPoint, endPoint, paint);
      canvas.drawLine(startPoint, endPoint.scale(1, -1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
