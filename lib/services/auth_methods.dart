import 'dart:typed_data';

import 'package:boom_client/models/user_auth_model.dart';
import 'package:boom_client/services/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//Get Users Details
// Future<UserModel> getUserDetails() async {
//    User currentUser = _auth.currentUser!;
//    DocumentSnapshot documentSnapshot =await firebaseFirestore.collection('users').doc(currentUser.uid).get();
//    return UserModel.fromSnap(documentSnapshot);
// }

  //Register Provider
  Future<String> signUpUser(
      {required String email,
      required String pass,
      required String confrimPass,
      required String providerLocation,
      required String contact,
      required String username,
      required bool isblocked,
      required Uint8List file}) async {
    String res = 'Wrong Email or Password';
    try {
      if (email.isNotEmpty ||
          pass.isNotEmpty ||
          confrimPass.isNotEmpty ||
          username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        String photoURL = await StorageMethods().uploadImageToStorage(
          'ProfilePics',
          file,
        );
        //Add User to the database with modal
        UserModel userModel = UserModel(
            isblocked: false,
            rate: 0,
            review: {},
            fullName: username,
            uid: cred.user!.uid,
            confrimPassword: confrimPass,
            email: email,
            contactNumber: contact,
            password: pass,
            userLocation: providerLocation,
            photoURL: photoURL);
        await firebaseFirestore
            .collection('clients')
            .doc(cred.user!.uid)
            .set(userModel.toJson());
        res = 'sucess';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //For Provider Sign In
  Future<String> loginUpUser({
    required String email,
    required String pass,
  }) async {
    String res = ' Wrong Email or Password';
    try {
      if (email.isNotEmpty || pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);

        res = 'sucess';
      }
    } on FirebaseException catch (e) {
      if (e == 'WrongEmail') {
        print(e.message);
      }
      if (e == 'WrongPassword') {
        print(e.message);
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
