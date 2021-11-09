import 'package:first_project_test/model/painter_model.dart';
import 'package:first_project_test/screens/home/home.dart';
import 'package:first_project_test/screens/home/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegistrationSplash extends StatelessWidget {
  final backgroundColor = 0xffF6F6F6;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.popUntil(
      //   context,
      //   ModalRoute.withName('/'),
      // );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Wrapper(),
        ),
      );
    });

    return ScreenUtilInit(
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
        home: Scaffold(
          backgroundColor: Color(backgroundColor),
          body: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 400,
                child: CustomPaint(
                  painter: CirclePainter(),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 127,
                  ),
                  child: Text(
                    'Ты супер!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.w,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 270.w,
                        height: 70.h,
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Color(backgroundColor),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0, 5), // Shadow position
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Мы рады тебя видеть',
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: EdgeInsets.only(top: 200.h),
                          child: Icon(
                            Icons.favorite,
                            size: 45.sp,
                            color: Color(0xffF1B488),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
