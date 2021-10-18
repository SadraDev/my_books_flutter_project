// @dart=2.9
import 'package:appandup_bookshelf/CustomWidgets/alert.dart';
import 'package:appandup_bookshelf/Screens/email_login_screen.dart';
import 'package:appandup_bookshelf/Screens/home_screen.dart';
import 'package:appandup_bookshelf/Screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogIn extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future googleIn() async {
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future emailLogIn(String email, String password, BuildContext context) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Alert(
            content: 'this email address dose not exist.',
            title: 'Email not found',
            child: 'register',
            onPressed: () {
              Navigator.pushNamed(context, RegisterScreen.id);
            },
          ),
        );
      } else if (e.code == 'wrong-password') {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Alert(
            content: 'password is wrong for this email.',
            title: 'wrong password',
            child: '',
            onPressed: () {},
          ),
        );
      }
    }

    User singedInUser = FirebaseAuth.instance.currentUser;

    if (singedInUser != null && !singedInUser.emailVerified) {
      await singedInUser.sendEmailVerification();
    }

    notifyListeners();
  }

  Future register(String email, String password, BuildContext context) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Alert(
            child: '',
            content: 'please enter a stronger password.',
            title: 'weak password',
            onPressed: () {},
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (context) => Alert(
            content: 'this email is already in use.',
            title: 'email in taken',
            child: 'log in',
            onPressed: () {
              Navigator.pushNamed(context, EmailLogin.id);
            },
          ),
        );
      }
    }

    User singedInUser = FirebaseAuth.instance.currentUser;

    if (singedInUser != null && !singedInUser.emailVerified) {
      await singedInUser.sendEmailVerification();
    }

    notifyListeners();
  }

  Future logOut(BuildContext context) async {
    googleSignIn.disconnect();
    _auth.signOut();

    Navigator.pop(context);

    notifyListeners();
  }
}
