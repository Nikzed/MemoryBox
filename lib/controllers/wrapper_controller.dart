import 'package:first_project_test/screens/additional_screens/search.dart';
import 'package:first_project_test/screens/home/audios.dart';
import 'package:first_project_test/screens/home/collections.dart';
import 'package:first_project_test/screens/home/home.dart';
import 'package:first_project_test/screens/home/profile.dart';
import 'package:first_project_test/screens/home/record.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class WrapperController extends GetxController {
  PageController pageController = PageController(
    initialPage: 0,
  );
  Rx<int> currentIndex = 0.obs;

  // TODO implement logic
  bool showDrawer = true;
  Rx<String> recordLabelText = 'Запись'.obs;
  Rx<FlutterSoundPlayer> player = FlutterSoundPlayer().obs;

  RxBool isPlaying = false.obs;
  RxString playingSong = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initPlayer();
  }

  Future<void> initPlayer() async {
    print('HELLOOOOOOOOOOOOOOO initPlayer()');
    await player.value.openAudioSession();
  }

  Future<void> startPlayer([String? songName]) async {
    songName != null ? playingSong.value = songName : null;

    if (player.value.isPlaying) {
      player.value.stopPlayer();
      playingSong.value = '';
      isPlaying.value = false;
      return;
    }

    isPlaying.value = true;
    await player.value.startPlayer(
        codec: Codec.aacADTS,
        fromURI: '/storage/emulated/0/SoundRecorder/$songName',
        whenFinished: () {
          playingSong.value = '';
          isPlaying.value = false;
          player.value.stopPlayer();
        });

    return;

    // player
    print('...');
    isPlaying.value = true;
    playingSong.value = 'какая-то запись.aac';
    await player.value.startPlayer(
        codec: Codec.aacADTS,
        fromURI: '/storage/emulated/0/SoundRecorder/какая-то запись.aac',
        whenFinished: () {
          playingSong.value = '';
          isPlaying.value = false;
          player.value.stopPlayer();
        });
  }

  @override
  void dispose() {
    pageController.dispose();
    // player.value.closeAudioSession();
    super.dispose();
  }

  List<Widget> pages = [
    Home(),
    Compilations(),
    Record(),
    Audios(),
    Profile(),
    // additional_screens
    Search(),
  ];

  void goTo(int page) {
    // currentIndex.value = 0;
    pageController.jumpToPage(page);
    print('current index: $currentIndex');
  }

  onPageChanged(page) {
    if (page < 5)
      currentIndex.value = page;
    else
      currentIndex.value = 0;
    // if (page == 1) {
    //   showDrawer = false;
    // } else {
    //   showDrawer = true;
    // }
    if (currentIndex == 2) {
      recordLabelText.value = '';
    } else {
      recordLabelText.value = 'Запись';
    }
    print('current index now is: $currentIndex, so it must be changed');
  }
}
