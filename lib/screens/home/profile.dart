import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/model/painter_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _image;
  ImagePicker picker = ImagePicker();
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: double.infinity,
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
                SizedBox(height: 50),
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
                  height: 228,
                  width: 228,
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
                    child: isEditing
                        ? Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.6),
                                    BlendMode.dstATop),
                                image:
                                      NetworkImage('https://firebasestorage.googleapis.com/v0/b/my-app-59705.appspot.com/o/CROPPED-nebo-oblaka-ozero-pirs.jpg?alt=media&token=4e4ecb89-98a6-4fd2-84af-cade727ee090')
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 50);
                                setState(() {
                                  _image = File(image!.path);
                                });
                              },
                            ),
                          )
                        : _image == null
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/loader.png',
                                image:
                                    'https://firebasestorage.googleapis.com/v0/b/my-app-59705.appspot.com/o/CROPPED-nebo-oblaka-ozero-pirs.jpg?alt=media&token=4e4ecb89-98a6-4fd2-84af-cade727ee090',
                                // 'http://ic.pics.livejournal.com/matchgirl_ru/19647654/307286/307286_original.jpg',
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                _image,
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Имя',
                  style: TextStyle(fontSize: 24),
                ),
                Container(
                  width: 292,
                  height: 22,
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    elevation: 9,
                    shadowColor: Colors.black.withOpacity(0.4),
                    child: Container(
                      child: Text(FirebaseAuth
                                  .instance.currentUser!.phoneNumber ==
                              null
                          ? '+38 0?? ?? ?? ???'
                          : '${FirebaseAuth.instance.currentUser!.phoneNumber}'),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  child: Text('Редактировать'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    print(FirebaseAuth.instance.currentUser!.uid);
                  },
                  child: Text('Подписка'),
                ),
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
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MyApp(),
                            ),
                          );
                          // Navigator.popUntil(
                          //   context,
                          //   ModalRoute.withName('init')
                          // );
                        },
                        child: Text('Выйти из приложения'),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          print(FirebaseAuth.instance.currentUser!.isAnonymous);
                        },
                        child: Text('Удалить аккаунт'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
