import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/models/audio_model.dart';
import 'package:first_project_test/models/painter_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double sw = Get.width;
  double sh = Get.height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: CustomScrollView(
        slivers: [
          _getSliverAppBar(),
          _getSliverList(),
          SliverToBoxAdapter(
            child: Container(
              height: 80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSliverAppBar() {
    return SliverAppBar(
      systemOverlayStyle:
      SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      backgroundColor: backgroundColor,
      expandedHeight: 0.5 * sh,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Container(
              width: sw,
              height: 0.7 * sh,
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
                padding: EdgeInsets.only(top: 85, right: 17, left: 17),
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
              top: 0.22 * sh,
              left: 0.035 * sw,
              child: Container(
                width: 0.45 * sw,
                height: 0.32 * sh,
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
                                color: backgroundColor,
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
              top: 0.22 * sh,
              right: 0.035 * sw,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {},
                child: Container(
                  width: 0.45 * sw,
                  height: 0.15 * sh,
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
              top: 0.39 * sh,
              right: 0.035 * sw,
              child: Container(
                width: 0.45 * sw,
                height: 0.15 * sh,
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 10), // changes position of shadow
                    ),
                  ],

                ),
              ),
            )
          ],
        ),
      ),
    );
    // TODO сделать current index == selected index для отображения состаяния isPlaying
    // TODO check dispose() потому что перерисовывает activity
    // github check2
  }

  Widget _getSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Аудиозаписи',
                  style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 0.3,
                    color: Color(0xff3A3A55),
                  ),
                ),
                Text('Открыть всё',
                  style: TextStyle(
                    color: Color(0xff3A3A55),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(height: 50),
          // Align(
          //   alignment: Alignment.center,
          //   child: Container(
          //     width: 200,
          //     child: Text(
          //       'Как только ты запишешь аудио, они появится здесь.',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         color: Color(0xff3A3A5580).withOpacity(0.5),
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 30),
          // SvgPicture.asset('assets/arrow_down.svg'),
          // ListView.builder(
          //   itemCount: 20,
          //   itemBuilder: (context, index){
          //     return AudioForm();
          //   },
          // ),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
          AudioForm(),
        ],
      ),

      // delegate: SliverChildBuilderDelegate(
      //   (context, index) {
      //     return getForm();
      //   },
      //   childCount: 10, // 1000 list items
      // ),
    );
  }

}
