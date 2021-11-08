import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(String number) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  users.add({'uid': uid, 'number': number, 'name': 'Иван?'});
  return;
}

Future<String?> getPhoneNumber(String phoneNumber) async {
  String number;

  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  QuerySnapshot eventsQuery =
      await ref.where('number', isEqualTo: phoneNumber).get();

  if (eventsQuery.size != 0) {
    number = eventsQuery.docs.last.get('number');
    return number;
  }
  return null;
}

