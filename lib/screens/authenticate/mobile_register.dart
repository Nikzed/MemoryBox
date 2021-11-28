import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/database/firebase.dart';
import 'package:first_project_test/models/painter_model.dart';
import 'package:first_project_test/screens/authenticate/registration_splash.dart';
import 'package:first_project_test/screens/home/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:get/get.dart';

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
        // Проверяем есть ли данный пользователь уже в базе данных
        getPhoneNumber(phoneController.text).then((value) => {
              if (value == null)
                {
                  print('СОЗДАЁМ ЮЗЕРА!'),
                  userSetup(phoneController.text),
                }
              else
                {print('ЮЗЕР УЖЕ ЕСТЬ!')}
            });
        Get.offAll(() => RegistrationSplash(), transition: Transition.zoom);
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
          height: 350,
          child: CustomPaint(
            painter: CirclePainter(),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: Text(
              'Регистрация',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 325),
            child: Text(
              'Введи номер телефона',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 279,
            height: 62,
            margin: EdgeInsets.only(top: 10),
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
                  fillColor: backgroundColor,
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
                fixedSize: Size(269, 49),
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
                fontSize: 16,
                color: Color(0xff3A3A55),
              ),
            ),
            onTap: () async {
              setState(() {
                showLoading = true;
              });
              UserCredential userCredential = await _auth.signInAnonymously();
              Get.offAll(() => Wrapper());
              setState(() {
                showLoading = false;
              });
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Container(
              width: 250,
              height: 115,
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
                  'Регистрация привяжет твои сказки к облаку, после чего они всегда будут с тобой',
                  style: TextStyle(fontSize: 14),
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
          height: 350,
          child: CustomPaint(
            painter: CirclePainter(),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: 100),
            child: Text(
              'Регистрация',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3),
            ),
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 325, left: 80, right: 80),
              child: Text(
                'Введи код из смс, чтобы мы тебя запомнили',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 279,
            height: 62,
            margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Material(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              elevation: 4,
              shadowColor: Colors.black,
              child: TextField(
                maxLength: 6,
                controller: otpController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: backgroundColor,
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
                fixedSize: Size(269, 49),
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
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Container(
              width: 250,
              height: 90,
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
                  'Регистрация привяжет твои сказки  к облаку, после чего они всегда будут с тобой',
                  style: TextStyle(fontSize: 12),
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
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Roboto'),
            home: Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: false,
              backgroundColor: backgroundColor,
              body: currentState == MobileVerificationState.SHOW_MOBILE_FORM
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
            ),
          );
  }
}
