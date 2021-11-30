import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Future<void> userSetup(String phoneNumber) async {
//   CollectionReference users = FirebaseFirestore.instance.collection('users');
//   FirebaseAuth auth = FirebaseAuth.instance;
//   String uid = auth.currentUser!.uid.toString();
//   users.add({'uid': uid, 'phoneNumber': phoneNumber, 'name': 'Иван?'});
//   return;
// }
//
// Future<String?> getPhoneNumber(String phoneNumber) async {
//
//   CollectionReference ref = FirebaseFirestore.instance.collection('users');
//
//   QuerySnapshot eventsQuery =
//       await ref.where('phoneNumber', isEqualTo: phoneNumber).get();
//
//   if (eventsQuery.size != 0) {
//     print(eventsQuery.docs.toString());
//     return eventsQuery.docs.last.get('phoneNumber');
//   }
//   return null;
// }