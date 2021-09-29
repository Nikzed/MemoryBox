import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0.0,
        leading: IconButton(
          icon: Text('hiii'),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: <Widget>[
          // TextButton.icon(onPressed: () {}, icon: icon, label: label)
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('Аудиосказки'))
          ],
        ),
      ),

    );
  }
}
