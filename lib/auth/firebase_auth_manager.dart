import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:payroute_desktop/auth/auth_manager.dart';

class FirebaseAuthManager implements AuthManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthManager.signInWithEmailAndPassword error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('FirebaseAuthManager.signInWithEmailAndPassword error: $e');
      rethrow;
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthManager.createUserWithEmailAndPassword error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('FirebaseAuthManager.createUserWithEmailAndPassword error: $e');
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      if (kIsWeb) {
        return await _auth.signInWithPopup(provider);
      } else {
        return await _auth.signInWithProvider(provider);
      }
    } catch (e) {
      debugPrint('FirebaseAuthManager.signInWithGoogle error: $e');
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithGithub() async {
    try {
      final provider = GithubAuthProvider();
      if (kIsWeb) {
        return await _auth.signInWithPopup(provider);
      } else {
        return await _auth.signInWithProvider(provider);
      }
    } catch (e) {
      debugPrint('FirebaseAuthManager.signInWithGithub error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('FirebaseAuthManager.signOut error: $e');
      rethrow;
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthManager.sendPasswordResetEmail error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('FirebaseAuthManager.sendPasswordResetEmail error: $e');
      rethrow;
    }
  }
}
