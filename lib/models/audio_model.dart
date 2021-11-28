import 'package:flutter/material.dart';

class AudioForm extends StatelessWidget {
  final name;
  final duration;
  const AudioForm({Key? key, this.name, this.duration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('аудио$name$duration'));
  }
}
