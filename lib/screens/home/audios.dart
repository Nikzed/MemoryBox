import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/models/audio_model.dart';
import 'package:first_project_test/models/painter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Audios extends StatefulWidget {
  @override
  _AudiosState createState() => _AudiosState();
}

class _AudiosState extends State<Audios> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 350,
          child: CustomPaint(
            painter: CirclePainter(
              color: Color(0xff5E77CE),
            ),
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
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Аудиозаписи',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Все в одном месте',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 42, right: 10),
            child: IconButton(
              color: Colors.white,
              iconSize: 38,
              icon: Icon(Icons.more_horiz),
              onPressed: () => null,
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 170, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '20 аудио',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '10:30 часов',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 165, right: 15),
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 46,
                width: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.4),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: SvgPicture.asset(
                        'assets/repeat.svg',
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(top: 165, right: 65),
            child: InkWell(
              onTap: () {},
              child: Container(
                height: 46,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFF8C84E2),
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Запустить все',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF8C84E2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 270),
            // child: Text('$_getAudioList'),
            // child: _getAudioList(),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: names.length,
              itemBuilder: (context, i) {
                return names.isEmpty
                    ? Text('nothing :(')
                    : AudioForm(
                        name: names[i],
                        duration: 0,
                      );
              },
            ),
          ),
        ),
      ],
    );
  }

  late List<FileSystemEntity> _folders;
  late List names = [];

  Future<void> _getFilesFromStorage() async {
    final directoryPath = '/storage/emulated/0/SoundRecorder';
    Directory directory = Directory(directoryPath);
    setState(() {
      _folders = directory.listSync(recursive: true, followLinks: false);
    });
    for (var i in _folders) {
      print(i.path.split('/').last);
      names.add(i.path.split('/').last);
    }
    print(names);
    // print(_folders.first.path.split('/').last);
  }

  // FutureBuilder<QuerySnapshot<Object?>> _getAudioList() {
  //   // FirebaseStorage storage = FirebaseStorage.instance;
  //   // Reference ref = storage.ref().child("image1" + DateTime.now().toString());
  //   // String results = ref.listAll().toString();
  //   // print('results $results');
  //   // //ref.getDownloadURL();
  //   //
  //   // return results;
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   // ListResult ref = await FirebaseStorage.instance.ref().listAll();
  //
  //   return FutureBuilder(
  //     future: getImages(),
  //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       return ListView.builder(
  //           padding: EdgeInsets.zero,
  //           shrinkWrap: true,
  //           itemCount: snapshot.data?.docs.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return ListTile(
  //               contentPadding: EdgeInsets.all(8.0),
  //               title: Text('${snapshot.data?.docs[index].data().toString()}'),
  //             );
  //           });
  //     },
  //   );
  // }

  Future<QuerySnapshot> getImages() {
    return firebaseFirestore.collection("upload-voice-firebase").get();
  }

  @override
  void initState() {
    _getFilesFromStorage();
    super.initState();
  }
}
