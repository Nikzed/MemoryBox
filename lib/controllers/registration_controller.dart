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

class RegistrationController extends GetxController {
  Rx<MobileVerificationState> currentState =
      MobileVerificationState.SHOW_MOBILE_FORM.obs;

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  late String verificationId;

  final phoneMask = MaskTextInputFormatter(
    mask: '+## ### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  Rx<bool> showLoading = false.obs;


  @override
  void onInit() {
    super.onInit();
    // ever(showLoading, event);
  }

  // void event(showLoading){
  //   if (showLoading.value) RxStatus.loading();
  // }

  void signInWithPhoneAuthCredential(
    PhoneAuthCredential phoneAuthCredential,
  ) async {
    String phoneNumber = phoneController.text;

      showLoading.value = true;

    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

        showLoading.value = false;

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
        showLoading.value = false;
      Get.snackbar('Ошибка!', 'Неправильно указан код',
          snackPosition: SnackPosition.BOTTOM);
      print('Error trace: $e');
    }
  }

  Future<void> verifyPhoneNumber() async {
    showLoading.value = true;
    try{
      print('ТУТ!!!');
      await auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (phoneAuthCredential) async {
        showLoading.value = false;
        // signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) async {
        showLoading.value = false;
        Get.snackbar('Ошибка!', verificationFailed.message.toString());
      },
      codeSent: (verificationId, resendingToken) async {
        showLoading.value = false;
        currentState.value = MobileVerificationState.SHOW_OTP_FORM;
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
    } catch (e){
      Get.snackbar('Ошибка!', e.toString());
      print('ОШИБКА');
    }
    print('ПРОШЛО');

  }

  Future<void> signInAnon() async {
    showLoading.value = true;

    UserCredential userCredential =
    await auth.signInAnonymously();
    print('UserCredential: $userCredential');
    Get.offAll(() => Wrapper());
    showLoading.value = false;
  }
}
