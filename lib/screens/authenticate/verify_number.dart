import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({
    Key? key,
    required this.number,
    required this.verificationId,
  }) : super(key: key);
  final number;
  final verificationId;

  @override
  _VerifyNumberState createState() => _VerifyNumberState(number, verificationId);
}

class _VerifyNumberState extends State<VerifyNumber> {
  final phoneNumber;
  final backgroundColor = 0xffF6F6F6;
  final _otpController = TextEditingController();
  String verificationId;

  _VerifyNumberState(this.phoneNumber, this.verificationId);

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) {
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: () =>
            MaterialApp(
                theme: ThemeData(fontFamily: 'Roboto'),
                home: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Color(backgroundColor),
                  // TODO: CHECK ERROR STATUS
                  body: true
                      ? Stack(children: [
                    Container(
                      width: double.infinity,
                      height: 400,
                      child: CustomPaint(
                        painter: CirclePainter(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 127.h, horizontal: 20.w),
                      child: Text(
                        'Регистрация',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 3.w),
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 275.h, left: 80.w, right: 80.w),
                          child: Text(
                            'Введи код из смс, чтобы мы тебя запомнили',
                            style: TextStyle(fontSize: 14.sp),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 279.w,
                        height: 62.h,
                        margin: EdgeInsets.only(top: 10.h),
                        alignment: Alignment.center,
                        child: Material(
                          borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                          elevation: 4,
                          shadowColor: Colors.black,
                          child: TextField(
                            controller: _otpController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(backgroundColor),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(top: 280),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xffF1B488),
                              fixedSize: Size(269.w, 49.h),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            onPressed: () async {
                              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider
                                  .credential(verificationId: verificationId,
                                  smsCode: _otpController.text,);
                              signInWithPhoneAuthCredential(phoneAuthCredential);
                            },
                            child: Text(
                              'Продолжить',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            )),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 50.h),
                        child: Container(
                          width: 250.w,
                          height: 90.h,
                          padding: EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Color(backgroundColor),
                            shape: BoxShape.rectangle,
                            borderRadius:
                            BorderRadius.all(Radius.circular(15.0)),
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
                              'Регистрация привяжет твои сказки  к облаку, после чего они всегда будут с тобой',
                              style: TextStyle(fontSize: 12.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                  ])
                      : Stack(
                    children: [
                      Container(
                        width: 500,
                        height: 400,
                        child: CustomPaint(
                          painter: CirclePainter(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 127.h, horizontal: 20.w),
                        child: Text(
                          'Регистрация',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 48.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 3.w),
                        ),
                      ),
                      Center(
                        child: Text("Верификация номера",
                            style: TextStyle(
                                color: Color(0xff8c84e2).withOpacity(0.7),
                                fontSize: 30)),
                      ),
                      Center(
                          child: Padding(
                              padding: EdgeInsets.only(top: 50.h),
                              child: Text("Использованный код неверен!"))),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 130.h),
                          child: CupertinoButton(
                              child: Text("Изменить номер"),
                              onPressed: () => Navigator.pop(context)),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 200.h),
                          child: CupertinoButton(
                              child: Text("Повторно отправить код"),
                              onPressed: () async {
                                setState(() {});
                              }),
                        ),
                      ),
                    ],
                  ),
                )));
  }
}


