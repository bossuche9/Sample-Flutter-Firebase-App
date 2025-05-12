import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sampleflutterapp/pages/reset_password.dart';

import '../pages/home.dart';
import '../pages/login.dart';

class AuthService {

  Future<void> signup({
    required String email,
    required String password,
    required BuildContext context
  }) async {
    UserCredential userCred;
    try {
     userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

     Fluttertoast.showToast(
       msg: "Registration Successful",
       toastLength: Toast.LENGTH_LONG,
       gravity: ToastGravity.SNACKBAR,
       backgroundColor: Colors.black54,
       textColor: Colors.white,
       fontSize: 14.0,
     );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>  Login()
          )
      );

    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    try{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({
        'email':email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: 'Could not save user info: ${e.message}',
      );
      return;
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context
  }) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>  const Home()
          )
      );

    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'An unexpected error occurred';
     switch (e.code) {
       case 'invalid-email':
         message = "That email address is not valid";
         break;
       case 'user-disabled':
         message = "This user's account has been disabled";
         break;
       case 'user-not-found':
         message = "No account found for that email. Please sign up first";
         break;
       case 'wrong-password':
         message = "Wrong password provided for that account";
         break;
       case 'network-request-failed':
         message = "A network error occurred";
         break;
     }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  Future<void> signout({
    required BuildContext context
  }) async {
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>  Login()
        )
    );
  }

  Future<void> resetPassword({
    required String email,
    required BuildContext context
  }) async {
    String message = "Password reset email sent";
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      await Future.delayed(const Duration(seconds: 1));
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ResetPassword()
          )
      );

    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

}
