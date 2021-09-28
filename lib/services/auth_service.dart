import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project_test/model/user.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on Firebase User
  UserModel? _userFromFirebaseUser(User? user){
    return user != null ? UserModel(uid: user.uid): null;
  }

  // auth change user stream
  Stream<UserModel?> get user{
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // sign in anonymously
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e){
      print(e.toString());
      return null;
    };
  }

  // sign in with phone number

  // register with phone number

  // sign out

}