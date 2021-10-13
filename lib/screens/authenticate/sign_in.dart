import 'package:first_project_test/model/painter_model.dart';
import 'package:first_project_test/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final backgroundColor = 0xffF6F6F6;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        theme: ThemeData(fontFamily: 'Roboto'),
        home: Scaffold(
          backgroundColor: Color(backgroundColor),
          body: Stack(children: [
            Container(
              width: 500,
              height: 400,
              child: CustomPaint(
                painter: CirclePainter(),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 157.h, horizontal: 67.w),
              child: Container(
                child: Column(children: [
                  Text(
                    'MemoryBox',
                    style: TextStyle(color: Colors.white, fontSize: 48),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Твой голос всегда рядом',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )
                ]),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Привет!',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 150),
                      child: Text(
                        'Мы рады видеть тебя здесь. Это приложение поможет записывать сказки и держать их в удобном месте не заполняя память на телефоне!',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: EdgeInsets.only(top: 350),
                      child: ElevatedButton(
                          onPressed: () {

                          },
                          child: Text(
                            'Продолжить',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                    ),
                  )
                ],
              ),
            ),

            // ОКНО текста с тенью

            // Align(
            //   alignment: Alignment.center,
            //   child: Container(
            //     width: 200.w,
            //     height: 57.h,
            //     margin: EdgeInsets.only(top: 100.h),
            //     alignment: Alignment.center,
            //     child: Text('data'),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       shape: BoxShape.rectangle,
            //       borderRadius: BorderRadius.all(Radius.circular(15.0)),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey.shade400,
            //           blurRadius: 10,
            //           offset: Offset(0, 2), // Shadow position
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // ОКНО текста с тенью

            // КНОПКА анонимного входа - начало

            // Container(
            //   alignment: Alignment.topCenter,
            //   padding: EdgeInsets.only(top: 500.0),
            //   child: ElevatedButton(
            //     child: Text('Sign in anon'),
            //     style: ButtonStyle(
            //         backgroundColor: MaterialStateProperty.all(Colors.pink)),
            //     onPressed: () async {
            //       dynamic result = await _auth.signInAnon();
            //
            //       if (result == null) {
            //         print('error signing in');
            //       } else {
            //         print('signed in');
            //         return result.uid;
            //       }
            //     },
            //   ),
            // ),

            // КНОПКА анонимного входа - конец
          ]),
        ),
      ),
    );
  }
}
