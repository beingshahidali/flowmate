import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;



  // sign in
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      //after creating a user, create document
      _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'email': email
      },SetOptions(merge: true));
      print("signin ___________________-");
      return userCredential;
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
  //create a new user
  Future<UserCredential>   signUpWithEmailAndPassword(String name, String email, String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      //after creating a user, create document
    _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid':userCredential.user!.uid,
        'name': name,
        'email': email
    });
    print('signup done----');
      return userCredential;
    }
    on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }

  //sign out

 Future<void> signOut() async{
    print('jordan');
    return await FirebaseAuth.instance.signOut();
 }
}