import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramclone/models/user.dart' as model;
import 'package:instagramclone/resources/storage_method.dart';
import 'package:instagramclone/utils/string.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty) {
        // Register user with firebase authentication
        UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        if (kDebugMode) {
          print("User uid: ${credential.user!.uid}");
        }

        String photoUrl = emptyString;

        if (file != null) {
          photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);
        }

        model.User user = model.User(
            username: username,
            uid: credential.user!.uid,
            email: email,
            bio: bio,
            photoUrl: photoUrl,
            followers: [],
            following: [],
        );

        // Add user to our database
        await _firestore.collection('users').doc(credential.user!.uid).set(user.toJson());

        res = "Success";
      }
    } on FirebaseAuthException catch(error) {
      if (error.code == 'invalid-email') {
        // Email format wrong
        res = 'The email is badly formatted!';
      } else if (error.code == 'weak-password') {
        // Very short password (less than 6 characters)
        res = 'Password should be at least 6 characters';
      }
    }
    catch(error) {
      res = error.toString();
    }
    return res;
  }

  /// Login user
  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch(error) {
      if (error.code == 'user-not-found' || error.code == 'wrong-password') {
        res = 'Wrong email or password';
      }
    }
    catch(error) {
      res = error.toString();
    }

    return res;
  }

}
