import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soap_factory/app/modules/login/models/user_model.dart';

class AccountRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  Future<FirebaseUser> signInWithCredentials(
      {String email, String password}) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      {String email, String password, String name}) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await createUserData(user: result.user, name: name);

      return result.user;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future createUserData({FirebaseUser user, String name}) async {
    final userModel = UserModel(
      uid: user.uid,
      name: name,
      email: user.email,
    );

    return _firestore
        .collection('users')
        .document(user.uid)
        .setData(userModel.toMap());
  }

  Future<void> sendPasswordResetEmail({String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }
}
