import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/model/painter_model.dart';
import 'package:first_project_test/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM,
  SHOW_OTP_FORM,
}

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  late String verificationId;

  bool showLoading = false;

  final backgroundColor = 0xffF6F6F6;
  final _phoneMask = MaskTextInputFormatter(
    mask: '+## ### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(e.message!),
        ),
      );
    }
  }

  getMobileFormWidget(context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          child: CustomPaint(
            painter: CirclePainter(),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 127.h, horizontal: 20.w),
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
            padding: EdgeInsets.only(top: 295.h),
            child: Text(
              'Введи номер телефона',
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 279.w,
            height: 62.h,
            margin: EdgeInsets.only(top: 10.h),
            alignment: Alignment.center,
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              elevation: 4,
              shadowColor: Colors.black,
              child: TextField(
                controller: phoneController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneMask],
                decoration: InputDecoration(
                  fillColor: Color(backgroundColor),
                  filled: true,
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
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () async {
                setState(() {
                  showLoading = true;
                });

                await _auth.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  //phoneController.text,
                  verificationCompleted: (phoneAuthCredential) async {
                    setState(() {
                      showLoading = false;
                    });
                    // signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  verificationFailed: (verificationFailed) async {
                    setState(() {
                      showLoading = false;
                    });
                    _scaffoldKey.currentState!.showSnackBar(
                      SnackBar(
                        content: Text(
                          verificationFailed.message!,
                        ),
                      ),
                    );
                  },
                  codeSent: (verificationId, resendingToken) async {
                    setState(() {
                      showLoading = false;
                      currentState = MobileVerificationState.SHOW_OTP_FORM;
                      this.verificationId = verificationId;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async {},
                );
              },
              child: Text(
                'Продолжить',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 400.0),
          child: InkWell(
            child: Text(
              'Позже',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  fontSize: 18.sp,
                  color: Color(0xff3A3A55)),
            ),
            onTap: () async {
              UserCredential userCredential = await _auth.signInAnonymously();
            },
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
                  'Регистрация привяжет твои сказки к облаку, после чего они всегда будут с тобой',
                  style: TextStyle(fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 400,
          child: CustomPaint(
            painter: CirclePainter(),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 127.h, horizontal: 20.w),
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
              padding: EdgeInsets.only(top: 275.h, left: 80.w, right: 80.w),
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
              borderRadius: BorderRadius.all(Radius.circular(100)),
              elevation: 4,
              shadowColor: Colors.black,
              child: TextField(
                controller: otpController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text,
                  );
                  signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                child: Text(
                  'Продолжить',
                  style: TextStyle(fontSize: 18, color: Colors.white),
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
                  'Регистрация привяжет твои сказки  к облаку, после чего они всегда будут с тобой',
                  style: TextStyle(fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return showLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ScreenUtilInit(
            builder: () => MaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              home: Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomInset: false,
                backgroundColor: Color(backgroundColor),
                body: currentState == MobileVerificationState.SHOW_MOBILE_FORM
                    ? getMobileFormWidget(context)
                    : getOtpFormWidget(context),
              ),
            ),
          );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }
}
