import 'dart:async';
import 'dart:io';
import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
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
  String _recorderTime = '00:00:00';

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

  @override
  void initState() {
    super.initState();
    // openAudioSession возвращает Future
    // Не открывать FlutterSoundPlayer или FlutterSoundRecorder до завершения Future метода
    _player!.openAudioSession().then((value) => {
          setState(() {
            _playerIsInited = true;
          }),
        });
    _openRecorder().then((value) => record());
  }

  @override
  void dispose() {
    stopPlayer();
    _player!.closeAudioSession();
    _player = null;

    stopRecorder();
    _recorder!.closeAudioSession();
    _recorder = null;
    super.dispose();
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

    StreamSubscription _recorderSubscription =
    _recorder!.onProgress!.listen((event) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(
          event.duration.inMilliseconds,
          isUtc: true);
      String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
      setState(() {
        _recorderTime = txt.substring(0, 8);
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
                Radius.circular(15),
              ),
            ),
            margin: EdgeInsets.all(10),
            color: Color(backgroundColor),
            child: Column(
              children: [
                InkWell(
                  onTap: getRecorderFunction(),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, right: 30),
                      child: Text('Отменить'),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      'Запись',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                // Container(
                //   width: double.infinity,
                //   child: Padding(
                //     padding:
                //         EdgeInsets.symmetric(vertical: 200, horizontal: 10),
                //     child: Divider(color: Colors.black),
                //   ),
                // ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: getPlaybackFunction(),
                    //color: Colors.white,
                    //disabledColor: Colors.grey,
                    child: Text(_player!.isPlaying ? 'Stop' : 'Play'),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 200),
                    child: Text('$_recorderTime'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
