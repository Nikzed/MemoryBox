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
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _getSliverAppBar(),
        _getSliverList(),
        SliverToBoxAdapter(
          child: Container(
            height: 80,
          ),
        ),
      ],
    );
  }

  Widget _getSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Color(backgroundColor),
      expandedHeight: 0.55.sh,
      automaticallyImplyLeading: false,
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
                padding: EdgeInsets.only(top: 85.h, right: 17.h, left: 17.h),
                child: Container(
                  height: 50,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Подборки',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          child: Text(
                            'Открыть всё',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 130),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Добавить',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(backgroundColor),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xd971A59F),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
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
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
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
        ),
      ),
    );
  }

  Widget _getSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Card(
            margin: const EdgeInsets.all(15),
            child: Container(
              color: Color(accentColor),
              height: 80,
              alignment: Alignment.center,
              child: Text(
                "Item $index",
                style: const TextStyle(fontSize: 30),
              ),
            ),
          );
        },
        childCount: 10, // 1000 list items
      ),
    );
  }
}
