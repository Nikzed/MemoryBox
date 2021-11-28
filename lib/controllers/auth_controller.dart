import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/screens/authenticate/sign_in.dart';
import 'package:first_project_test/screens/home/splash.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> firebaseUser;
  get isRegistered => auth.currentUser!.phoneNumber!.isNotEmpty;

  @override
  void onReady() {
    super.onReady();

    firebaseUser = Rx<User?>(auth.currentUser);

    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      // if the user is not found then the user is navigated to the SignIn
      Get.offAll(() => const SignIn());
    } else {
      // if the user exists and logged in, the the user is directed to SplashScreen
      Get.offAll(() => SplashScreen());
    }
  }

  void signInWithPhoneAuthCredential(
    PhoneAuthCredential phoneAuthCredential,
    String phoneNumber,
  )
  async {
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
        getPhoneNumber(phoneNumber).then((value) => {
              if (value == null)
                {
                  print('СОЗДАЁМ ЮЗЕРА!'),
                  userSetup(phoneNumber),
                }
              else
                {print('ЮЗЕР УЖЕ ЕСТЬ!')}
            });

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => RegistrationSplash(),
        //   ),
        // );
      }
    } on FirebaseAuthException catch (e) {
      // setState(() {
      //   showLoading = false;
      // });

      Get.showSnackbar(
        GetBar(
          title: 'Ошибка!',
          message: e.toString(),
        ),
      );
    }
  }

  Future<String?> getPhoneNumber(String phoneNumber) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('users');

    QuerySnapshot eventsQuery =
        await ref.where('phoneNumber', isEqualTo: phoneNumber).get();

    if (eventsQuery.size != 0) {
      print(eventsQuery.docs.toString());
      return eventsQuery.docs.last.get('phoneNumber');
    }
    return null;
  }

  Future<void> userSetup(String phoneNumber) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String uid = auth.currentUser!.uid.toString();
    users.add({'uid': uid, 'phoneNumber': phoneNumber, 'name': 'Иван?'});
    return;
  }
}
