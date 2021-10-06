import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  final backgroundColor = 0xffF6F6F6;
  final accentColor = 0xff8c84e2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Color(backgroundColor),
              expandedHeight: MediaQuery.of(context).size.height * 0.5,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: CustomPaint(
                    size: Size(20, 0),
                    painter: MyPainter(),
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                children: <Widget>[
                  Container(
                    width: 500,
                    height: 500,
                    child: CustomPaint(
                      painter: CirclePainter(),
                    ),
                  ),
                  Positioned(
                    top: 116,
                    left: 17,
                    child: Text('Подборки',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'Consolas')),
                  ),
                  Positioned(
                    top: 110,
                    right: 10,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Открыть всё',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Consolas'),
                      ),
                      style: ButtonStyle(),
                    ),
                  ),
                  Positioned(
                    top: 166,
                    left: 16,
                    child: Container(
                      width: 173,
                      height: 240,
                      child: Container(
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 60, 23, 0),
                              child: Text(
                                'Здесь будет твой набор сказок',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(50, 160, 0, 49),
                              child: TextButton(
                                onPressed: () {},
                                child: Text('Добавить',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(backgroundColor),
                                      fontSize: 14,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xd971A59F),
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 166,
                    left: 205,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {},
                      child: Container(
                        width: 173,
                        height: 112,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Color(0xffF1B488),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                          child: Text(
                            'Тут',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 294,
                    left: 205,
                    child: Container(
                      width: 173,
                      height: 112,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xd9678BD2),
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        child: Text(
                          'И тут',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    color: Colors.orange[100 * (index % 9)],
                    child: Text('orange ${index + 1}'),
                  );
                },
                childCount: 18,
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 90),
                  child: Text(
                    'Аудисказки',
                    style: TextStyle(fontSize: 24),
                  )),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'Меню',
                  style: TextStyle(fontSize: 22, color: Color(0xd93A3A5580)),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 80, left: 40),
                child: Stack(
                  children: [
                    RichText(text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.home),
                          ),
                        ),
                        TextSpan(text: 'Главная'),
                      ]
                    ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dashboard(context) {
    return SliverAppBar();
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, -6), Offset(20, -6), paint);
    canvas.drawLine(Offset(0, 0), Offset(20, 0), paint);
    canvas.drawLine(Offset(0, 6), Offset(20, 6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


