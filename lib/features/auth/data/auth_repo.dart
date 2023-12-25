import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepoProvider = Provider<AuthRepo>((ref) {
  return AuthRepo();
});

class AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.currentUser?.sendEmailVerification();
      return _firebaseAuth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      await _firebaseAuth.currentUser?.reload();
      if (!_firebaseAuth.currentUser!.emailVerified) {
        throw Exception("click the link in your inbox to verify your email!");
      }
      return _firebaseAuth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;
}
