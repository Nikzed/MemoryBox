import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/screens/home/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM,
  SHOW_OTP_FORM,
}

class RegistrationController extends GetxController{

  Rx<MobileVerificationState> currentState =
      MobileVerificationState.SHOW_MOBILE_FORM.obs;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final phoneMask = MaskTextInputFormatter(
    mask: '+## ### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Rx<bool> showLoading = false.obs;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential,
      ) async {
    String phoneNumber = phoneController.text;
    // setState(() {
    //   showLoading = true;
    // });

    try {
      final authCredential =
      await auth.signInWithCredential(phoneAuthCredential);

      // setState(() {
      //   showLoading = false;
      // });

      if (authCredential.user != null) {
        // Проверяем есть ли данный пользователь уже в базе данных
        authController.getPhoneNumber(phoneNumber).then((value) => {
          if (value == null)
            {
              print('СОЗДАЁМ ЮЗЕРА!'),
              authController.userSetup(phoneNumber),
            }
          else
            {print('ЮЗЕР УЖЕ ЕСТЬ!')}
        });

        Get.offAll(() => Wrapper());
      }
    } on FirebaseAuthException catch (e) {
      // setState(() {
      //   showLoading = false;
      // });
      Get.snackbar('Ошибка!', 'Неправильно указан код', snackPosition: SnackPosition.BOTTOM);
    }
  }
}