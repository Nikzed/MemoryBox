import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/controllers/registration_controller.dart';
import 'package:first_project_test/models/painter_model.dart';
import 'package:first_project_test/screens/authenticate/registration_splash.dart';
import 'package:first_project_test/screens/home/wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';



class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  RegistrationController registrationController = RegistrationController();


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
            padding: EdgeInsets.only(top: 300),
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
                controller: registrationController.phoneController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                inputFormatters: [registrationController.phoneMask],
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
              onPressed: () {
                registrationController.verifyPhoneNumber();

                // setState(() {
                //   showLoading = true;
                // });
                // await auth.verifyPhoneNumber(
                //   phoneNumber: registrationController.phoneController.text,
                //   //phoneController.text,
                //   verificationCompleted: (phoneAuthCredential) async {
                //     setState(() {
                //       showLoading = false;
                //     });
                //     // signInWithPhoneAuthCredential(phoneAuthCredential);
                //   },
                //   verificationFailed: (verificationFailed) async {
                //     setState(() {
                //       showLoading = false;
                //     });
                //     Get.snackbar('Ошибка!', verificationFailed.message.toString());
                //   },
                //   codeSent: (verificationId, resendingToken) async {
                //     setState(() {
                //       showLoading = false;
                //       registrationController.currentState.value = MobileVerificationState.SHOW_OTP_FORM;
                //       this.verificationId = verificationId;
                //     });
                //   },
                //   codeAutoRetrievalTimeout: (verificationId) async {},
                // );
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
          padding: EdgeInsets.only(top: 380.0),
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
            onTap: () {
              registrationController.signInAnon();
              // setState(() {
              //   showLoading = true;
              // });
              // //UserCredential userCredential =
              // await auth.signInAnonymously();
              // Get.offAll(() => Wrapper());
              // setState(() {
              //   showLoading = false;
              // });
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Container(
              width: 250,
              height: 105,
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
            child: Container(
              width: 320,
              child: Padding(
                padding: EdgeInsets.only(top: 280, left: 80, right: 80),
                child: Text(
                  'Введи код из смс, чтобы мы тебя запомнили',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
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
                controller: registrationController.otpController,
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
                // TODO rebuild
                PhoneAuthCredential phoneAuthCredential =
                    PhoneAuthProvider.credential(
                  verificationId: registrationController.verificationId,
                  smsCode: registrationController.otpController.text,
                );
                registrationController.signInWithPhoneAuthCredential(phoneAuthCredential);
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


  @override
  Widget build(BuildContext context) {
    return registrationController.showLoading.value
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: backgroundColor,
              body: registrationController.currentState.value == MobileVerificationState.SHOW_MOBILE_FORM
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
            );
  }
}
