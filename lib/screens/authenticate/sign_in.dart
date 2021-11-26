import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'mobile_register.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final backgroundColor = 0xffF6F6F6;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
        home: Scaffold(
          backgroundColor: Color(backgroundColor),
          body: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 350,
                child: CustomPaint(
                  painter: CirclePainter(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 127,
                  horizontal: 34,
                ),
                child: Column(
                  children: [
                    Text(
                      'MemoryBox',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 46,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Твой голос всегда рядом',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 290),
                        child: Text(
                          'Привет!',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Text(
                          'Мы рады видеть тебя здесь.\nЭто приложение поможет записывать сказки и держать их в удобном месте не заполняя память на телефоне!',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 320),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffF1B488),
                              fixedSize: Size(269, 49),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            onPressed: () {
                              _navigateToNextScreen(context);
                            },
                            child: Text(
                              'Продолжить',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Registration(),
      ),
    );
  }
}
