import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/constants/constants.dart';
import 'package:first_project_test/models/painter_model.dart';
import 'package:first_project_test/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _image;
  ImagePicker picker = ImagePicker();
  bool isEditing = false;
  TextEditingController _controller = TextEditingController();
  String? number = FirebaseAuth.instance.currentUser?.phoneNumber;
  final phoneMask = MaskTextInputFormatter(
    mask: '+38 ### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    // даём возможность пользователю выйти из режима корректировки
    // нажатием кнопки назад
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          setState(
            () {
              isEditing = false;
              shouldPop = !shouldPop;
            },
          );
          return shouldPop;
        },
        child: ListView(
          padding: EdgeInsets.zero,
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 350,
                    child: CustomPaint(
                      painter: CirclePainter(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: 40, left: 5),
                      child: IconButton(
                        color: Colors.white,
                        iconSize: 28,
                        icon: Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SizedBox(height: 45),
                        Text(
                          'Профиль',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Твоя частичка',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                            // TODO make image in base64 and store in Firebase
                            child: isEditing
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.6),
                                          BlendMode.dstATop,
                                        ),
                                        image: _image == null
                                            ? NetworkImage(
                                                'https://firebasestorage.googleapis.com/v0/b/my-app-59705.appspot.com/o/CROPPED-nebo-oblaka-ozero-pirs.jpg?alt=media&token=4e4ecb89-98a6-4fd2-84af-cade727ee090',
                                              )
                                            : FileImage(_image!)
                                                as ImageProvider,
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        XFile? image = await picker.pickImage(
                                          source: ImageSource.gallery,
                                          imageQuality: 50,
                                        );
                                        setState(() {
                                          _image = File(image!.path);
                                        });
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          'assets/photo.svg',
                                          width: 75,
                                          height: 75,
                                        ),
                                      ),
                                    ),
                                  )
                                : _image == null // ? CachedNetworkImage
                                    ? FadeInImage.assetNetwork(
                                        placeholder: 'assets/loader.png',
                                        image:
                                            'https://firebasestorage.googleapis.com/v0/b/my-app-59705.appspot.com/o/CROPPED-nebo-oblaka-ozero-pirs.jpg?alt=media&token=4e4ecb89-98a6-4fd2-84af-cade727ee090',
                                        // 'http://ic.pics.livejournal.com/matchgirl_ru/19647654/307286/307286_original.jpg',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        _image!,
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        // Stack(
                        //   children: [
                        //
                        //   ],
                        // ),
                        Text(
                          'Имя',
                          style: TextStyle(fontSize: 24),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 50,
                          width: 300,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(0, 5),
                              )
                            ],
                          ),
                          child: isEditing
                              ? TextField(
                                  controller: _controller,
                                  inputFormatters: [phoneMask],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                  ),
                                )
                              : Text(number == null || number == ''
                                  ? '+00 000 000 00 00'
                                  : '${FirebaseAuth.instance.currentUser!.phoneNumber}'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          child: Text('Редактировать'),
                          onTap: () {
                            setState(() {
                              isEditing = !isEditing;
                            });
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            Get.snackbar(
                              'title',
                              'message',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            print(FirebaseAuth.instance.currentUser?.uid);
                          },
                          child: Text(
                            "Подписка",
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: Offset(0, -5),
                                )
                              ],
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 15,
                          width: 230,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('150/500 мб'),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (FirebaseAuth
                                          .instance.currentUser?.isAnonymous ==
                                      true) {
                                    FirebaseAuth.instance.currentUser!.delete();
                                  } else {
                                    await FirebaseAuth.instance.signOut();
                                  }
                                  Get.offAll(() => SignIn());
                                },
                                child: Text(
                                  'Выйти из приложения',
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: backgroundColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          title: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Вы уверенны?',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          content: Container(
                                            height: 170,
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Все аудиофайлы исчезнут и восстановить аккаунт будет невозможно',
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 50),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                      width: 100,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          // TODO
                                                        },
                                                        child: Text('Удалить'),
                                                        style: ButtonStyle(
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            Colors.white,
                                                          ),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            Color(0xffE27777),
                                                          ),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              // side: BorderSide(
                                                              //     color:
                                                              //         Colors.black),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 100,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          print(
                                                              'is registered: ${authController.isRegistered}');
                                                        },
                                                        child: Text('Нет'),
                                                        style: ButtonStyle(
                                                          // elevation: MaterialStateProperty.all(5),
                                                          foregroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            Color(0xff8C84E2),
                                                          ),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                            backgroundColor,
                                                          ),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                              // side: BorderSide(
                                                              //   color:
                                                              //       Color(0xff8C84E2),
                                                              // ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                  // _deleteAccount();
                                  // Navigator.of(context).pushReplacement(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => MyApp(),
                                  //   ),
                                  // );
                                },
                                child: Text(
                                  'Удалить аккаунт',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                              // SizedBox(height: 70),
                            ],
                          ),
                        ),
                        SizedBox(height: 100),
                        // SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot eventsQuery = await collection
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    eventsQuery.docs.first.reference.delete();

    FirebaseAuth.instance.currentUser!.delete();
  }
}
