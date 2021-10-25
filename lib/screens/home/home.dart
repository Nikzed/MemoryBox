import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final backgroundColor = 0xffF6F6F6;

  final accentColor = 0xff8c84e2;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => MaterialApp(
        // theme: ThemeData(fontFamily: 'Roboto'),
        home: Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: 70.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon(), // make custom House icon
                    Icon(Icons.dashboard),
                  ],
                ),
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Color(backgroundColor),
                expandedHeight: 0.55.sh,
                leading: Builder(
                  builder: (context) => IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: 'открыть меню',
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                  children: <Widget>[
                    Container(
                      width: 1.sw,
                      height: 0.55.sh,
                      child: CustomPaint(
                        painter: CirclePainter(),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 85.h, right: 17.h, left: 17.h),
                          child: Container(
                            height: 50,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text('Подборки',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    child: Text('Открыть всё',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                    Positioned(
                      top: 0.22.sh,
                      left: 0.035.sw,
                      child: Container(
                        width: 0.45.sw,
                        height: 0.32.sh,
                        child: Container(
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 60, 23, 0),
                                child: Text(
                                  'Здесь будет твой набор сказок',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 130),
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
                      top: 0.22.sh,
                      right: 0.035.sw,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {},
                        child: Container(
                          width: 0.45.sw,
                          height: 0.15.sh,
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
                      top: 0.39.sh,
                      right: 0.035.sw,
                      child: Container(
                        width: 163.w,
                        height: 0.15.sh,
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
                      RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: Icon(Icons.home),
                                ),
                              ),
                              TextSpan(text: 'Главная'),
                            ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
