import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:share_plus/share_plus.dart';

enum RecordState {
  RECORDING,
  PLAYING,
}

class RecordController extends GetxController {
  Rx<RecordState> state = RecordState.RECORDING.obs;

  RxBool storagePermissionIsGranted = false.obs;
  RxString fileName = ''.obs;
  RxString directoryPath = '/storage/emulated/0/SoundRecorder'.obs;
  String filePath = '';

  // -- Recorder --
  StreamSubscription? _recorderSubscription;

  Rx<FlutterSoundRecorder> recorder = FlutterSoundRecorder().obs;
  RxBool isRecorderInitialized = false.obs;

  RxBool get isRecording => recorder.value.isRecording.obs;
  RxString recorderText = '0:00:00'.obs;
  RxDouble noiseInDb = 0.0.obs;
  RxList<double> noisesList = List.generate(20, (index) => 0.0).obs;

  // -- Player --
  StreamSubscription? _playerSubscription;

  Rx<FlutterSoundPlayer> player = FlutterSoundPlayer().obs;

  RxString playerCurrentText = '00:00'.obs;
  RxString playerMaxText = '00:00'.obs;
  RxDouble maxDuration = 1.0.obs;
  RxDouble sliderPos = 0.0.obs;
  RxBool isPlaying = false.obs;

  @override
  void onInit() {
    print('onInit start');
    print('initing recorder');
    _initRecorder();
    print('initing player');
    _initPlayer();
    super.onInit();
  }

  // ----- RECORDER START -----

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Recording permission required.');
    }
    await recorder.value.openAudioSession();

    isRecorderInitialized.value = true;
    print('_isRecorderInitialized $isRecorderInitialized');
    // запускаем запись после инициализации
    await toggleRecording();
  }

  Future startRecorder() async {
    if (!isRecorderInitialized.value) {
      return;
    }
    Directory directory = await getApplicationDocumentsDirectory();
    // Возможность инициализировать все записанные аудио
    // String filePath = directory.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.aac';
    // Временный файл
    // filePath = directory.path + '/' + 'temp' + '.aac';
    // Постоянный файл TODO: решить куда записывать
    fileName.value = await _generateFileName();
    filePath = directoryPath + '/' + fileName.value + '.aac';
    await _addRecorderListener();
    await recorder.value.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );
    print('recording to $filePath');
  }

  Future<void> _addRecorderListener() async {
    try {
      await recorder.value.setSubscriptionDuration(
        Duration(milliseconds: 150),
      );

      await initializeDateFormatting();

      _recorderSubscription = await recorder.value.onProgress!.listen((event) {
        if (event.decibels != null) {
          noiseInDb.value = event.decibels!.ceilToDouble();
        }
        for (int i = 0; i < 19; i++) {
          noisesList[i] = noisesList[i + 1];
        }

        noisesList.removeLast();
        noisesList.add(noiseInDb.value);

        DateTime date = DateTime.fromMillisecondsSinceEpoch(
          event.duration.inMilliseconds,
          isUtc: true,
        );
        // trouble here
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

        recorderText.value = txt.substring(0, 8);
      });
    } catch (e) {
      print('Exception occured: ${e.toString()}');
      Get.snackbar('Exception', e.toString());
    }
  }

  Future<void> stopRecorder() async {
    if (!isRecorderInitialized.value) {
      return;
    }
    // fileName.value = await _generateFileName();
    await recorder.value.stopRecorder();
    await cancelRecorderSubscriptions();
    noisesList.value = List.generate(20, (index) => 0.0);
    recorderText.value = '0:00:00';
    //_writeFileToStorage();
  }

  Future<void> cancelRecorderSubscriptions() async {
    if (_recorderSubscription != null) {
      await _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  Future<void> _writeFileToFirebase() async {
    FirebaseFirestore.instance
        .collection('data')
        .add({'text': 'data added through an app'});
  }

  Future<void> writeFileToStorage() async {
    await _getStoragePermission();
    await _createDirectory();
    await _createFile();
  }

  Future<void> _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      storagePermissionIsGranted.value = true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      storagePermissionIsGranted.value = false;
    }
  }

  Future<void> _createDirectory() async {
    bool isDirectoryCreated = await Directory(directoryPath.value).exists();
    if (!isDirectoryCreated) {
      Directory(directoryPath.value).create()
          // The created directory is returned as a Future.
          .then((Directory directory) {
        print(directory.path);
      });
    }
  }

  Future<void> _createFile() async {
    // fileName.value = await _generateFileName();
    File(directoryPath + '/' + fileName.value)
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
    if (await File(directoryPath + '/' + 'Запись №$i.aac').exists()) {
      return _generateFileName(i + 1);
    }
    // было
    // return 'Запись №$i';
    return 'Запись №$i.aac';
  }

  Future<void> toggleRecording() async {
    print('HELLO!');
    if (isRecording.value) {
      print('stopping');
      await stopRecorder();
    } else {
      print('starting');
      await startRecorder();
    }
  }

  // ----- RECORDER END -----

  // ----- PLAYER START -----

  Future<void> _initPlayer() async {
    await player.value.openAudioSession();
    await _addPlayerListener();
  }

  Future<void> _addPlayerListener() async {
    await player.value.setSubscriptionDuration(
      Duration(milliseconds: 10),
    );

    await initializeDateFormatting();

    _playerSubscription = player.value.onProgress!.listen((event) {
      maxDuration.value = event.duration.inMilliseconds.toDouble();

      if (maxDuration.value < 0) {
        maxDuration.value = 0.0;
      }

      sliderPos.value = min(
        event.position.inMilliseconds.toDouble(),
        maxDuration.value,
      );

      if (sliderPos.value < 0.0) {
        sliderPos.value = 0.0;
      }

      String txt = DateFormat('mm:ss:SS', 'en_GB').format(
        DateTime.fromMillisecondsSinceEpoch(
          event.position.inMilliseconds,
          isUtc: true,
        ),
      );
      playerCurrentText.value = txt.substring(0, 5);

      String txt1 = DateFormat('mm:ss:SS', 'en_GB').format(
        DateTime.fromMillisecondsSinceEpoch(
          event.duration.inMilliseconds,
          isUtc: true,
        ),
      );
      playerMaxText.value = txt1.substring(0, 5);
    });
  }

  Future<void> startPlayer() async {
    try {
      Codec codec = Codec.aacADTS;
      if (player.value.isPaused) {
        await player.value.resumePlayer();
      } else {
        await player.value.startPlayer(
            fromURI: filePath,
            codec: codec,
            whenFinished: () {
              isPlaying.value = false;
            });
      }
    } on Exception catch (err) {
      print('ERROR HAPPENED');
      player.value.logger.e('error: $err');
    }
  }

  //
  // Future<void> seekToSec(int milliSec) async {
  //   if (player.value.isPlaying) {
  //     await player.value.seekToPlayer(
  //       Duration(milliseconds: milliSec),
  //     );
  //   }
  //   sliderPos.value = milliSec.toDouble();
  // }
  //
  Future<void> playback15Seconds() async {
    await player.value.seekToPlayer(
      Duration(
        milliseconds: sliderPos.value.toInt() - 15000,
      ),
    );
  }

  Future<void> playForward15Seconds() async {
    await player.value.seekToPlayer(
      Duration(
        milliseconds: sliderPos.value.toInt() + 15000,
      ),
    );
  }

  //
  Future<void> seekToPlayer(int milliseconds) async {
    try {
      if (player.value.isPlaying) {
        await player.value.seekToPlayer(
          Duration(milliseconds: milliseconds),
        );
      }
    } on Exception catch (err) {
      player.value.logger.e('error: $err');
    }
  }

  //
  // Future stopPlayer() async {
  //   await player.value.pausePlayer();
  // }
  //
  // Future<void> cancelPlayerSubscriptions() async {
  //   if (_playerSubscription != null) {
  //     await _playerSubscription!.cancel();
  //     _playerSubscription = null;
  //   }
  // }
  //
  // Future<void> togglePlayer() async {
  //   print('_isPlaying: $isPlaying');
  //   if (!playing.value) {
  //     playing.value = true;
  //     await startPlayer();
  //   } else {
  //     playing.value = false;
  //     await stopPlayer();
  //   }
  // }

  Future<void> togglePlayer() async {
    if (isPlaying.value) {
      isPlaying.value = !isPlaying.value;
      return await player.value.pausePlayer();
    }
    isPlaying.value = !isPlaying.value;
    return await startPlayer();
  }

  // ----- PLAYER END -----

  Future<void> onFileUploadButtonPressed() async {
    print('HELLO!!!!!!');
    List<String> paths = [filePath];
    print('paths $paths');
    await Share.shareFiles(
      paths,
      subject: 'Boom',
      text: ''
    );
    // setState(() {
    //   _isUploading = true;
    // });
    return;
    try {
      print('filePath: $filePath');
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;
      await firebaseStorage
          .ref('upload-voice-firebase')
          .child(
            filePath.substring(filePath.lastIndexOf('/'), filePath.length),
          )
          .putFile(
            File(filePath),
          );
      _onUploadComplete();
    } catch (error) {
      print(
          'Error occurred while uploading to Firebase:\n ${error.toString()}');
      Get.snackbar('Error', 'Error occurred while uploading to Firebase');
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

  // TODO: можно удалять аудио
  // void _clean() async {
  //   if (recordingFile != null) {
  //     try {
  //       await File(recordingFile!).delete();
  //     } on Exception {
  //       // ignore
  //     }
  //   }
  // }

  @override
  void onClose() {
    // recorder
    stopRecorder();
    recorder.value.closeAudioSession();
    isRecorderInitialized.value = false;
    cancelRecorderSubscriptions();
    // player
    player.value.closeAudioSession();
    // cancelPlayerSubscriptions();
    // player.close();
    super.onClose();
  }
}
