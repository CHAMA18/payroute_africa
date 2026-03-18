import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payroute_desktop/auth/firebase_auth_manager.dart';
import 'package:payroute_desktop/models/user_model.dart';
import 'package:payroute_desktop/services/user_service.dart';

class AuthProvider extends ChangeNotifier {
  static const String _rememberMeKey = 'remember_me';
  
  final FirebaseAuthManager _authManager = FirebaseAuthManager();
  final UserService _userService = UserService();
  
  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;
  bool _isInitialized = false;
  bool _isDemoMode = false;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel {
    if (_isDemoMode) {
      return UserModel(
        id: 'demo-1234',
        email: 'demo@payroute.com',
        accountType: 'personal',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        name: 'Demo User',
      );
    }
    return _userModel;
  }
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null || _isDemoMode;
  bool get rememberMe => _rememberMe;
  bool get isInitialized => _isInitialized;
  bool get isDemoMode => _isDemoMode;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _rememberMe = prefs.getBool(_rememberMeKey) ?? false;
      
      // Check current Firebase auth state
      _firebaseUser = _authManager.currentUser;
      
      // If user is logged in but didn't choose to remain logged in, sign them out
      if (_firebaseUser != null && !_rememberMe) {
        await _authManager.signOut();
        _firebaseUser = null;
        _userModel = null;
      } else if (_firebaseUser != null) {
        // Load user model if authenticated and remember me is enabled
        try {
          _userModel = await _userService.getUserById(_firebaseUser!.uid);
        } catch (e) {
          debugPrint('AuthProvider._initializeAuth: Could not fetch user from Firestore: $e');
          // Create a basic user model from Firebase Auth data if Firestore fails
          _userModel = UserModel(
            id: _firebaseUser!.uid,
            email: _firebaseUser!.email ?? '',
            accountType: 'personal',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      }
    } catch (e) {
      debugPrint('AuthProvider._initializeAuth error: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
    
    // Listen for auth state changes
    _authManager.authStateChanges.listen(
      _onAuthStateChanged,
      onError: (error) {
        debugPrint('AuthProvider auth state stream error: $error');
      },
    );
  }

  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_rememberMeKey, value);
    } catch (e) {
      debugPrint('AuthProvider.setRememberMe error: $e');
    }
    notifyListeners();
  }

  void enableDemoMode() {
    _isDemoMode = true;
    notifyListeners();
  }

  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    if (user != null) {
      try {
        _userModel = await _userService.getUserById(user.uid);
      } catch (e) {
        debugPrint('AuthProvider._onAuthStateChanged: Could not fetch user from Firestore: $e');
        // Create a basic user model from Firebase Auth data if Firestore fails
        _userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          accountType: 'personal',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } else {
      _userModel = null;
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authManager.signInWithEmailAndPassword(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String accountType, {String? name, String? phone}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authManager.createUserWithEmailAndPassword(email, password);
      
      if (credential.user != null) {
        final now = DateTime.now();
        final userModel = UserModel(
          id: credential.user!.uid,
          email: email,
          accountType: accountType,
          name: name,
          phone: phone,
          createdAt: now,
          updatedAt: now,
        );
        
        // Try to create user in Firestore, but don't fail if it doesn't work
        // (Firestore permissions may not be set up yet)
        try {
          await _userService.createUser(userModel);
        } catch (e) {
          debugPrint('AuthProvider.signUp: Firestore user creation failed (permissions may not be set): $e');
          // Continue anyway - user is authenticated
        }
        _userModel = userModel;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      debugPrint('AuthProvider.signUp error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authManager.signInWithGoogle();
      if (credential.user != null) {
        await _handleSocialUserRegistration(credential.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Google sign-in failed. Please try again.';
      debugPrint('AuthProvider.signInWithGoogle error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGithub() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _authManager.signInWithGithub();
      if (credential.user != null) {
        await _handleSocialUserRegistration(credential.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'GitHub sign-in failed. Please try again.';
      debugPrint('AuthProvider.signInWithGithub error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<void> _handleSocialUserRegistration(User user) async {
    try {
      _userModel = await _userService.getUserById(user.uid);
    } catch (e) {
      // User does not exist, create new user document
      final now = DateTime.now();
      final newUserModel = UserModel(
        id: user.uid,
        email: user.email ?? '',
        accountType: 'personal',
        createdAt: now,
        updatedAt: now,
      );
      try {
        await _userService.createUser(newUserModel);
        _userModel = newUserModel;
      } catch (e2) {
        debugPrint('AuthProvider._handleSocialUserRegistration error saving to Firestore: $e2');
        _userModel = newUserModel;
      }
    }
  }

  Future<void> signOut() async {
    try {
      if (_isDemoMode) {
        _isDemoMode = false;
        notifyListeners();
        return;
      }
      // Clear remember me preference when signing out
      await setRememberMe(false);
      await _authManager.signOut();
      _firebaseUser = null;
      _userModel = null;
      notifyListeners();
    } catch (e) {
      debugPrint('AuthProvider.signOut error: $e');
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authManager.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _errorMessage = _getErrorMessage(e.code);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      // Extract error code from the exception string if possible
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('configuration-not-found')) {
        _errorMessage = _getErrorMessage('configuration-not-found');
      } else if (errorString.contains('user-not-found')) {
        _errorMessage = _getErrorMessage('user-not-found');
      } else if (errorString.contains('invalid-email')) {
        _errorMessage = _getErrorMessage('invalid-email');
      } else {
        _errorMessage = 'Unable to send reset email. Please check your email address.';
      }
      debugPrint('AuthProvider.sendPasswordResetEmail error: $e');
      notifyListeners();
      return false;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email. Please log in instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'configuration-not-found':
        return 'Password reset is not configured. Please contact support.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
