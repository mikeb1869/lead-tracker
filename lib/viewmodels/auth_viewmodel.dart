import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

// A class that extends ValueNotifier to manage authentication state
class AuthViewModel extends ValueNotifier<User?> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final StreamSubscription<User?> _authSubscription;

  AuthViewModel() : super(null) {
    // Listen to authentication state changes
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      value = user; // Update the current user state
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  // Method to sign in with email and password
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No account found with this email.');
        case 'invalid-credential':
          throw Exception('Incorrect email or password. Please try again.');
        case 'wrong-password':
          throw Exception('Incorrect password. Please try again.');
        case 'invalid-email':
          throw Exception('Please enter a valid email address.');
        case 'user-disabled':
          throw Exception('This account has been disabled.');
        default:
          throw Exception('Sign in failed. Please try again.');
      }
    }
  }

  // Method to register a new user with email and password
  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('An account already exists with this email.');
        case 'weak-password':
          throw Exception('The password is too weak.');
        case 'invalid-email':
          throw Exception('Please enter a valid email address.');
        default:
          throw Exception('Sign up failed. Please try again.');
      }
    }
  }

  // Method to sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }
}
