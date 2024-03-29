import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/controllers/wrapper_controller.dart';
import 'package:first_project_test/models/audio_form_model.dart';
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

  final WrapperController f = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: backgroundColor,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
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
      ),
    );
  }

  Widget _getSliverAppBar() {
    return SliverAppBar(
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
      backgroundColor: backgroundColor,
      expandedHeight: 390,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 450,
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
              top: 170,
              left: 10,
              child: Container(
                width: 180,
                height: 250,
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
                            onPressed: () {
                              f.startPlayer();
                            },
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
              top: 170,
              right: 10,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {},
                child: Container(
                  width: 180,
                  height: 120,
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
              top: 300,
              right: 10,
              child: Container(
                width: 180,
                height: 120,
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
                Text(
                  'Открыть всё',
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
