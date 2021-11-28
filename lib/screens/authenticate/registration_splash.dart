import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/models/painter_model.dart';
import 'package:first_project_test/screens/home/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationSplash extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => Wrapper(), transition: Transition.fade);
    });

    return Scaffold(
          backgroundColor: backgroundColor,
          body: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 350,
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
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 270,
                        height: 75,
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: backgroundColor,
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
                              fontSize: 22,
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
                          padding: EdgeInsets.only(top: 200),
                          child: Icon(
                            Icons.favorite,
                            size: 45,
                            color: Color(0xffF1B488),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
