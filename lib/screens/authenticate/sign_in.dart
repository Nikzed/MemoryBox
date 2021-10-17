import 'package:first_project_test/model/painter_model.dart';
import 'package:first_project_test/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
              margin: EdgeInsets.symmetric(vertical: 127.h, horizontal: 34.w),
              child: Container(
                child: Column(children: [
                  Text(
                    'MemoryBox',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 48.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3.w),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Твой голос всегда рядом',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  )
                ]),
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 320),
                      child: Text(
                        'Привет!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 70),
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
                      padding: EdgeInsets.only(top: 280),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffF1B488),
                            fixedSize: Size(269.w, 49.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          onPressed: () {
                            _navigateToNextScreen(context);
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

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Registration()));
  }
}

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final backgroundColor = 0xffF6F6F6;
  final AuthService _auth = AuthService();
  final phoneMask = MaskTextInputFormatter(
      mask: '+# (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: () => MaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              home: Scaffold(
                resizeToAvoidBottomInset: false,
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
                          padding: EdgeInsets.only(top: 295.h),
                          child: Text(
                            'Введи номер телефона',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        )),
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
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 400.0),
                      child: InkWell(
                        child: Text('Позже',
                          style: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 2,fontSize: 18.sp, color: Color(0xff3A3A55)),
                        ),
                        onTap: () async {
                          dynamic result = await _auth.signInAnon();

                          if (result == null) {
                            print('error signing in');
                          } else {
                            print('signed in');
                            return result.uid;
                          }
                        },
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
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [phoneMask],
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
                        // decoration:
                        // BoxDecoration(
                        //   color: Color(backgroundColor),
                        //   shape: BoxShape.rectangle,
                        //   borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.grey.shade400,
                        //       blurRadius: 10,
                        //       offset: Offset(0, 2), // Shadow position
                        //     ),
                        //   ],
                        // ),
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
                            child: Text('Регистрация привяжет твои сказки  к облаку, после чего они всегда будут с тобой',
                            style: TextStyle(fontSize: 12.sp),textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    )
                  ])),
            ));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => VerifyNumber()));
  }
}

enum Status { Waiting, Error }

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({Key? key, this.number}) : super(key: key);
  final number;

  @override
  _VerifyNumberState createState() => _VerifyNumberState(number);
}

class _VerifyNumberState extends State<VerifyNumber> {
  final phoneNumber;
  Status _status = Status.Waiting;
  var _verificationId;
  final backgroundColor = 0xffF6F6F6;

  _VerifyNumberState(this.phoneNumber);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: () => MaterialApp(
            theme: ThemeData(fontFamily: 'Roboto'),
            home: Scaffold(
              backgroundColor: Color(backgroundColor),
              body: _status != Status.Error
                  ? Stack(children: [
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
                                  setState(() {
                                    this._status = Status.Waiting;
                                  });

                                  _verifyPhoneNumber();
                                }),
                          ),
                        ),
                      ],
                    ),
            )));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future _verifyPhoneNumber() async {}
}
