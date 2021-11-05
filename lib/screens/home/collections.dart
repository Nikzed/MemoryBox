import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class Collections extends StatefulWidget {
  @override
  _CollectionsState createState() => _CollectionsState();
}

class _CollectionsState extends State<Collections> {
  static const int bufferSize = 2048;
  static const int sampleRate = 44100;


  StreamSubscription? _audioSubscription;
  Stream? audioStream;

  IOSink? _sink;
  StreamController<List<double>>? audioFFT;
  bool isRecording = false;
  bool isPlaying = false;
  List<int>? _sampleAudio;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Audio Visualizer Demo'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                child: Center(
                  child: StreamBuilder(
                    stream: audioFFT?.stream ?? null,
                    builder: (context, snapshot) {
                      if (snapshot.data == null) return Container();

                      final buffer = snapshot.data as List<double>;
                      final wave = buffer.map((e) => e-0.25).toList();

                      return Container(
                        child: CustomPaint(
                          child: new Container(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              // isExtended: true,
              child: Icon(isRecording ? Icons.stop_rounded : Icons.mic_rounded),
              backgroundColor: Colors.red,
              onPressed: () {
                if (isRecording) {
                } else {
                }
              },
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              // isExtended: true,
              child: Icon(isPlaying ? Icons.stop_rounded : Icons.music_note),
              backgroundColor: Colors.blue,
              onPressed: () async {
                if (!isPlaying) {
                } else {
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}